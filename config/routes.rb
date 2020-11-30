Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  devise_for :users
  
  root to: 'maps#index'

  resources :maps, only: :index

  # match '*path' => redirect('/'), via: :get
  # match '*url' => redirect('/'), via: :get

  get 'drivers/splitter', to: 'drivers#splitter'
  get 'locales/change', to: 'locales#change'

  resources :drivers, shallow: true do
    resources :cars, shallow: true do
      resources :rides, shallow: true do
        collection do
          get :menu
        end
        member do
          patch :execute
          post  :complete
          patch :abort
          patch :reject
        end
      end
      patch :select_workhorse, on: :member
    end
    patch :lock, on: :member
    get :car_stats, on: :member
  end

  resources :payments do
    get :accept, on: :collection
    patch :pay_off, on: :member
  end

  resources :attachments, only: :destroy
 
end
