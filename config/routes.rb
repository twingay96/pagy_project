Rails.application.routes.draw do
  root "comments#index"
  resources :comments do
    collection do
      post :index
    end
  end
end
