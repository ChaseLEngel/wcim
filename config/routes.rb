Rails.application.routes.draw do

	root "ingredients#index"

  devise_for :users

	resources :users do
		resources "favorites", shallow: true
	end

	delete "/recipe/:recipe_id/favorite", to: "favorites#destroy", as: "destroy_recipe_favorite"
	get "/ingredients/autocomplete", to: "ingredients#autocomplete"
	get "/ingredients/sortby/:sortby", to: "ingredients#sortby", as: "sortby"
	get "/ingredients/delete/:id", to: "ingredients#destroy", as: "session_delete"
	resources "ingredients"
	resources :recipes do
		resources "favorites", shallow: true
	end

end
