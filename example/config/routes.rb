Example::Application.routes.draw do
  resources :posts do
    member do
      put :scope_request
    end
    resources :comments
  end

  resources :orders do
    member do
      get :member_demo
    end
    collection do
      get :collection_demo
    end

    resources :order_items
  end

  match "/docs" => Raddocs::App, :anchor => false
end
