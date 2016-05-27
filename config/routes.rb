Spree::Core::Engine.routes.draw do
  namespace :admin do
    resources :subscriptions do
      resource :customer, controller: 'subscriptions/customer_details'
      resources :issues, controller: 'subscriptions/issues_details'
      match 'issues/:id/ship', to: 'subscriptions/issues_details#ship', via: :get, as: :issue_ship
      match 'issues/:id/unship', to: 'subscriptions/issues_details#unship', via: :get, as: :issue_unship
    end

    resources :products, as: :products do
      resources :issues, controller: 'products/issues'
      match 'issues/:id/ship', to: 'products/issues#ship', via: :get, as: :issue_ship
      match 'issues/:id/unship', to: 'products/issues#unship', via: :get, as: :issue_unship
    end

    resources :users do
      member do
        get :subscriptions
      end
    end
  end
end
