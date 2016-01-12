class CreateIngredientQuantities < ActiveRecord::Migration
  def change
    create_table :ingredient_quantities do |t|
      t.float :quantity
      t.references :ingredient, index: true, foreign_key: true
      t.references :recipe, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
