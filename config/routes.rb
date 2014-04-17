Rolodexx::Application.routes.draw do
  resource  :session,  only: [:show]
  resources :contacts, only: [:index, :show, :create, :update, :destroy]
end
