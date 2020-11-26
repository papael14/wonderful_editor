class AddStatusiToArticle < ActiveRecord::Migration[6.0]
  def change
    add_column :articles, :statusi, :integer, default: 0
  end
end
