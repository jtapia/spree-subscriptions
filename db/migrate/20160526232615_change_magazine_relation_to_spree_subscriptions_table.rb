class ChangeMagazineRelationToSpreeSubscriptionsTable < ActiveRecord::Migration
  def change
    rename_column :spree_subscriptions, :magazine_id, :product_id
  end
end
