
# Create Ingredients and Recipes
def recipes_ingredients
	puts "Creating Recipes and Ingredients"
	Recipe.delete_all
	Ingredient.delete_all
	recipes = Nokogiri::XML(File.open("#{Rails.root}/db/recipes.exl")).xpath("//recipe")
	recipes.each do |recipe|
		instructions = "N/A"
		# Find matching memo for recipe
		recipes.xpath("//memo").each do |m|
			if m.parent == recipe
				instructions = m.to_s.split("ESHA Research")[1].split("]]")[0]
				break
			end
		end
		r = Recipe.create(name: recipe[:description], instructions: instructions)
		puts "RECIPE: #{r.name}(#{r.id})"
		# Find all ingredients that are used in that recipe
		recipes.xpath("//RecipeItem").each do |item|
			if item.parent == recipe
				# Try to preserve the Ingredient has many recipes relation.
				i = Ingredient.find_or_create_by(name: item[:ItemName])
				puts "\tINGREDIENT: #{i.name}(#{i.id})"
				# Create ingredient relation with recipe. This also creates the recipe relation with ingredient
				r.ingredients << i
				IngredientQuantity.create(quantity: item[:itemQuantity], recipe_id: r.id, ingredient_id: i.id)
			end
		end
	end
end

# Creates 20 Users and creates 10 Favorites for each User.
def users_favorites
	puts "Creating Users and Favorites"
	User.delete_all
	Favorite.delete_all
	alphabet = "a"
	20.times do 
		u = User.create(email: "#{alphabet}@#{alphabet}.com", password: "a")
		puts "USER: #{u.email}(#{u.id})"
		20.times do
			random_recipe = Recipe.all.sample.id
			while !(Favorite.find_by(user_id: u.id, recipe_id: random_recipe)).nil?
				random_recipe = Recipe.all.sample.id
			end
			f = Favorite.create(user_id: u.id, recipe_id: random_recipe)
			puts "\tFAVORITE: #{f.recipe.name}(#{f.id})"
		end
		alphabet.next!
	end
end

recipes_ingredients
users_favorites
