Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  post 'event_handler' => 'pull_requests#event_handler'
  resources :result

  root 'application#home'

end
