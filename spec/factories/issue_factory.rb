FactoryGirl.define do
  factory :issue, class: Spree::Issue do
    # associations:
    product { FactoryGirl.create(:product, subscribable: true) }
    sequence(:name) {|n| "Issue number #{n}" }
  end
end
