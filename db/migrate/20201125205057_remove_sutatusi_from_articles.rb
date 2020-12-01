class RemoveSutatusiFromArticles < ActiveRecord::Migration[6.0]
  def change
    remove_column :articles, :statusi, :integer
    change_column_default :articles, :status, from:"", to: "draft"
  end
end
