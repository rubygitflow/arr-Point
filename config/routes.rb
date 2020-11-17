Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  devise_for :users
  
  root to: 'maps#index'

  resources :maps do
    collection do
      get :change_language
    end
  end

  # match '*path' => redirect('/'), via: :get

  get 'drivers/splitter', to: 'drivers#splitter'
  # resources :drivers

  resources :drivers, shallow: true do
    resources :cars, shallow: true do
      member do
        post :select_workhorse
      end
    end
  end

  resources :attachments, only: :destroy
end
