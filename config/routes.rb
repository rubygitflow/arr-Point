Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'maps#index'

  resources :maps do
    collection do
      get :change_language
    end
  end
end
