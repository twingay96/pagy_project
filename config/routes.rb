Rails.application.routes.draw do
  resources :artists
  resources :posts
  #root "posts#index"

  root "comments#index"
  resources :comments do
    collection do
      post :index
    end
  end
end
