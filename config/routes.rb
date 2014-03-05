WhiteCollar::Application.routes.draw do
  root :to => 'tickets#index'

  get '/clients/submit'
  post 'clients/actually_assign'
  get '/clients/assign'
  get '/clients/approve'
  post '/clients/approve_client'
  post '/clients/approve_client_edit'
  post '/clients/disapprove_client'
  post '/projects/change_project'
  post '/projects/select_project'
  match  '/receipts/my_receipts/:id', to: 'receipts#my_receipts', via: 'get', as: 'my_receipts'
  get '/reports/student_summary'
  get '/reports/activities'
  get '/reports/sales'
  get '/reports/team_summary'
  get '/users/need_help'
  get '/users/unauthorized'
  get '/users/create_new_section'
  get '/users/teachers'
  post '/users/assign_teacher_to_section'
  post '/users/input_students_parse'
  post '/users/change_is_enabled'
  post '/users/change_student_status'
  post '/users/show_section'
  post '/users/set_section'
  delete '/users/delete_incorrect'
  post '/users/new'
  get '/users/in_section'
  get '/tickets/release'
  post '/users/change_teacher'

  resources :sessions, only: [:new, :create, :destroy]
  resources :tickets
  resources :clients
  resources :projects, except: :show
  resources :users
  resources :receipts do
    resources :actions 
  end
  
  resources :actions
  
  match '/signin', to: 'sessions#new', via: 'get'
  match '/signout', to: 'sessions#destroy', via: 'delete'
  match '/receipts/index/user', to: 'receipts#index', via: 'get'

  # Safety net if the projects update somehow gets stopped
  match'/projects/:id', to: 'projects#index', via: 'get'

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
