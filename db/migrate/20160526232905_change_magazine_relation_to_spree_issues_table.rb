class ChangeMagazineRelationToSpreeIssuesTable < ActiveRecord::Migration
  def change
    rename_column :spree_issues, :magazine_id, :product_id
    rename_column :spree_issues, :magazine_issue_id, :product_issue_id
  end
end