Rails.application.routes.draw do

  get 'placements/show'

  devise_for :users, controllers: { sessions: 'users/sessions' }
  devise_for :admins, controllers: { sessions: 'admins/sessions' }
  post 'campaigns/update'
  post 'campaigns/show'
  post 'placements/show'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'campaigns#show'

end
