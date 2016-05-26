class SubscriptionValidator < ActiveModel::Validator
  def validate(record)
    unless record.product.subscribable?
      record.errors[:product] << 'Should be a subscribable product'
    end
  end
end
