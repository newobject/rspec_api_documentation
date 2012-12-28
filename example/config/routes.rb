Example::Application.routes.draw do
  resources :orders do
    member do
      get :member_demo
    end
    collection do
      get :collection_demo
    end
  end

  match "/docs" => Raddocs::App, :anchor => false
end
