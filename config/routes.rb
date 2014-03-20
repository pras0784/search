SearchEngine::Application.routes.draw do
  root to: 'home#index'
  get '/suggest' => 'home#suggest'
end
