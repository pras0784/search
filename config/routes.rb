SearchEngine::Application.routes.draw do
  root to: 'home#index'
  get '/suggest' => 'home#suggest', as: :suggest
  get '/proxy_img' => 'home#img', as: :image
end
