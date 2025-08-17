Rails.application.routes.draw do
  resources :decks
  resources :study_sessions, only: [ :create ]
  patch "/flashcards/batch-update", to: "flashcards#batch_update_flashcards_stats"
  resources :flashcards
  get "/users/stats", to: "users#get_stats"
  get "/users/todays-progress", to: "users#get_todays_progress"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
