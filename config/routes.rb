Rails.application.routes.draw do

  # scope "(:locale)", locale: /en|jp/ do
  scope "/:locale" do
    devise_for :users, controllers: { sessions: 'users/sessions' }
    devise_for :admins, controllers: { sessions: 'admins/sessions' }
    post 'campaigns/update'
    post 'campaigns/show'
    post 'placements/show'
    get 'placements/show'
    get 'campaigns/show'
    get 'admins/test'

    # The priority is based upon order of creation: first created -> highest priority.
    # See how all your routes lay out with "rake routes".
  end
  get '/:locale' => 'campaigns#show'
  # You can have the root of your site routed with "root"
  
  root 'campaigns#show'
  # root 'admins#show'

end
