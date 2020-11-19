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
      resources :rides, shallow: true do
        collection do
          get :menu
        end
        member do
          patch :execute
          patch :complete
          patch :abort
          patch :reject
        end
      end
      patch :select_workhorse, on: :member
    end
    patch :lock, on: :member
  end

  resources :attachments, only: :destroy

end
