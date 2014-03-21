SearchEngine::Application.routes.draw do
  root to: 'home#index'
  get '/suggest' => 'home#suggest', as: :suggest
  get '/proxy_img' => 'home#proxy_img', as: :proxy_img
end
