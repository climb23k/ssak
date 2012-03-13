Ssak::Application.routes.draw do
  devise_for :users,  :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  get 'pages/home'
  get 'pages/about'
  match '/about' => 'pages#about', :as=>'about'
  root :to => 'pages#home'
end
