class Spree::Issue < ActiveRecord::Base
  belongs_to :product, class_name: 'Spree::Product'
  belongs_to :product_issue, class_name: 'Spree::Product'
  has_many :shipped_issues

  delegate :subscriptions, to: :product

  validates :name,
            presence: true,
            unless: "product_issue.present?"

  scope :shipped, -> { where("shipped_at IS NOT NULL") }
  scope :unshipped, -> { where("shipped_at IS NULL") }

  scope :shipped, -> { where("shipped_at IS NOT NULL") }
  scope :unshipped, -> { where("shipped_at IS NULL") }

  def name
    product_issue.present? ? product_issue.name : read_attribute(:name)
  end

  def ship!
    subscriptions.eligible_for_shipping.each{ |s| s.ship!(self) }
    update_attribute(:shipped_at, Time.now)
  end

  def unship!
    Spree::Subscription.where(id: self.shipped_issues.pluck(:subscription_id)).each{ |s| s.unship!(self) }
    update_attribute(:shipped_at, nil)
  end

  def shipped?
    !shipped_at.nil?
  end

  def product
    # override getter method to include deleted products, as per https://github.com/radar/paranoia
    Spree::Product.unscoped { super }
  end

  def product_issue
    # override getter method to include deleted products, as per https://github.com/radar/paranoia
    Spree::Product.unscoped { super }
  end

end
