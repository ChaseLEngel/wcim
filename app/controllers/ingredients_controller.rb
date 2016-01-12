class IngredientsController < ApplicationController

	before_action :authenticate_user!, :except => [:index, :autocomplete, :show, :create, :destroy, :sortby]

	def index
		@session_ingredients = (session[:ingredients] ||= "").split(",")
		@recipes = Ingredient.search(session[:ingredients], session[:sorted_by])
		@ingredient = Ingredient.new
	end

	def autocomplete
		respond_to do |format|
			format.json{
				render json: Ingredient.where("name LIKE ?", "%#{params[:term]}%").take(10).map(&:name)
			}
		end
	end

	def sortby
		session[:sorted_by] = params[:sortby]
		redirect_to ingredients_path
	end

	def create
		return redirect_to ingredients_path if params[:name].empty?
		if session[:ingredients].nil?
			session[:ingredients] = params[:name]+","
		else
			session[:ingredients] << params[:name]+","
		end
		redirect_to ingredients_path
	end

	def destroy
		session[:ingredients] = session[:ingredients].split(",").delete_if{|i| i == params[:id]}.join(",")
		session[:ingredients] += "," unless session[:ingredients].empty?
		redirect_to ingredients_path
	end

end
