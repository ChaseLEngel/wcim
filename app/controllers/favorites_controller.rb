class FavoritesController < ApplicationController

	def index
		@user_favorites = users_favorites
	end

	def create
		@favorite = recipe.favorites.new(user_id: current_user.id).save
		redirect_to recipe
	end

	def destroy
		(favorite || favorite_by_recipe).destroy
		redirect_to :back
	end

	private
		
		def favorite_by_recipe
			Favorite.find_by(["user_id = :user AND recipe_id = :recipe", {user: current_user.id, recipe: recipe.id}])
		end

		def recipe
			Recipe.find(params[:recipe_id])
		end

		def favorite
			Favorite.find_by(id: params[:id])
		end

		def users_favorites
			Favorite.where(user_id: current_user.id)
		end
end
