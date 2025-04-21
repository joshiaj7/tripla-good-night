Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  scope "v1" do
    scope "/users" do
      post "/login", to: "user#login"
      post "/signup", to: "user#signup"
    end

    scope "/schedules" do
      post "/clock-in", to: "schedule#clock_in"
    end

    scope "/watchlists" do
      post "/follow", to: "watchlist#follow"
      post "/unfollow", to: "watchlist#unfollow"
    end
  end
end
