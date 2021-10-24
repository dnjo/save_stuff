Rails.application.routes.draw do
  get 'items', to: 'item#list'
  post 'integration/reddit', to: 'integration#new_reddit'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
