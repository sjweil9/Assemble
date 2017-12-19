Rails.application.routes.draw do
    if Rails.env.development?
        mount LetterOpenerWeb::Engine, at: "/letter_opener"
    end

    root 'users#new'

    get 'signin' => 'users#new', as: "sign_in"
    post 'users' => 'users#create', as: "create_user"
    get 'users/forgot' => 'users#forgot_pw', as: "forgot_password"
    post 'users/forgot/send' => 'users#send_reset', as: "send_pw_reset"
    get 'users/reset/:token' => 'users#reset_pw_form', as: "reset_password_form"
    post 'users/reset/:token' => 'users#reset_pw', as: "reset_password"
    get 'users/confirm/:token' => 'users#confirm_email', as: "confirm_email"
    get 'users/unlock/:token' => 'users#unlock_account', as: "unlock_account"
    get 'users/:id/edit' => 'users#edit', as: "edit_user"
    put 'users/:id' => 'users#update', as: "update_user"

    post 'sessions' => 'sessions#create', as: "log_in"
    delete 'sessions' => 'sessions#destroy', as: "log_out"

    get 'events' => 'events#index', as: "events"
    post 'events' => 'events#create', as: "create_event"
    get 'events/past' => 'events#past', as: "old_events"
    get 'events/:id' => 'events#show', as: "show_event"
    delete 'events/:id' => 'events#destroy', as: "delete_event"
    put 'events/:id' => 'events#update', as: "update_event"
    get 'events/:id/edit' => 'events#edit', as: "edit_event"

    post 'attends/:id' => 'attends#create', as: "join_event"
    delete 'attends/:id' => 'attends#destroy', as: "leave_event"

    post 'comments/:event_id' => 'comments#create', as: "create_comment"
    delete 'comments/:id' => 'comments#destroy', as: "delete_comment"
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
