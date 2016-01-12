class RecipesController < ApplicationController

	before_action :authenticate_user!, :except => [:show]

	def show
		@recipe = Recipe.find(params[:id])
		@favorite = Favorite.new
	end
end
