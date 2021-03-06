WhiteCollar::Application.routes.draw do
  root :to => 'tickets#index'
  
  get "static_pages/about_us"
  match  '/users/duplicate_student', :to => 'users#duplicate_student', via: :post
  post   '/clients/approve_client_edit'
  post   'clients/assign'#actually_assign'
  get    '/clients/show_assign_for'#assign'
  get    '/clients/approve'
  post   '/clients/approve_client'
  post   '/clients/disapprove_client'
  get    '/clients/submit'
  get    '/clients/more_allowed'
  post   '/projects/change_project'
  post   '/projects/select_project'
  match  '/receipts/my_receipts/:id', to: 'receipts#my_receipts', via: 'get', as: 'my_receipts'
  get    '/reports/student_summary'
  get    '/reports/activities'
  get    '/reports/sales'
  get    '/reports/team_summary'
  get    '/reports/bonus'
  delete '/reports/delete_bonus'
  post   '/reports/edit_bonus'
  get    '/reports/team_data'
  get    '/reports/clients'
  get    '/reports/end_of_semester_data'
  post   '/users/assign_teacher_to_section'
  post   '/users/another_teacher_to_section'
  post   '/users/change_teacher'
  get    '/users/create_new_section'
  get    '/users/download_help'
  get    '/users/need_help'
  get    '/users/unauthorized'
  get    '/users/teachers'
  post   '/users/input_students_parse'
  post   '/users/change_is_enabled'
  post   '/users/change_student_status'
  post   '/users/show_section'
  post   '/users/set_section'
  delete '/users/delete_incorrect'
  get    '/users/new_teacher'
  get    '/users/in_section'
  post   '/users/remove_member'
  post   '/tickets/release'
  get    '/tickets/get_sys_time'
  get    '/tickets/updates'
  get    '/tickets/getClient'
  get    '/projects/projects_list'
  get    '/projects/convert_to_excel'
  get    '/users/tickets_left'
  get    '/clients/edited_clients_excel'
  get    '/clients/pending_clients_excel'
  get    '/tickets/left'
  
  resources :sessions, only: [:new, :create, :destroy]
  resources :tickets
  resources :clients
  resources :projects
  resources :users
  resources :receipts do
    resources :actions 
  end  
  resources :bonus_types
  resources :actions
  
  match '/signin', to: 'sessions#new', via: 'get'
  match '/signout', to: 'sessions#destroy', via: 'delete'
  match '/no_project', to: 'sessions#no_project', via: 'get'
  match '/receipts/index/user', to: 'receipts#index', via: 'get'
  
  post "versions/:id/revert_action" => "versions#revert_action", :as => "revert_action_version" #added by Miyashita for testing versioning undo
  
  post "versions/:id/revert_assign" => "versions#revert_assign", :as => "revert_assign_version" #added by Miyashita for testing versioning undo

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
