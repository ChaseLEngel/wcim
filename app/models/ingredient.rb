class Ingredient < ActiveRecord::Base
  has_and_belongs_to_many :recipes

	def quantity recipe_id
		IngredientQuantity.where(recipe_id: recipe_id, ingredient_id: self.id).take.quantity
	end

	def self.search data, sorted_by
		return [] if data.nil?
		recipes = Hash.new
		data.split(",").each do |d|
			Ingredient.where("name LIKE ?", "%#{d}%").each do |ingredient|
				ingredient.recipes.each do |recipe| 
					# Create new recipe entry if there is no existing one for that recipe else increment the existing one.
					# This shows that the user has multiple ingredients for the recipe.
					if not recipes.include?(recipe)
						recipes.store(recipe, 1) 
					else
						recipes[recipe] = recipes[recipe] + 1
					end
				end
			end
		end
		if sorted_by == "favorites"
			return recipes.sort_by{|key,value| key.favoriteCount }.reverse
		else # Sort by ingredients ratio
			return recipes.sort_by{|key,value| (key.ingredientsCount/value).to_f }
		end
	end

end
