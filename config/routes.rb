Rails.application.routes.draw do
  resources :posts
  root "comments#index"
  resources :comments do
    collection do
      post :index
    end
  end
end
