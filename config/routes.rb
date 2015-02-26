HlaPortal::Application.routes.draw do

  get 'hlas/serotype_select1', to: 'hlas#serotype_select1'
  get 'hlas/serotype_select2', to: 'hlas#serotype_select2'
  get 'hlas/destroy'
  get 'hlas', to: 'hlas#index'
  get 'hlas/newa'
  get 'hlas/newb'
  get 'hlas/newc'
  get 'hlas/edita'
  get 'hlas/editb'
  get 'hlas/editc'
  get 'locus_as/show', to: 'patients#show'
  get 'locus_bs/show', to: 'patients#show'
  get 'locus_cs/show', to: 'patients#show'

  resources :users do
    member do
      get :following, :followers
    end
  end

  resources :sessions, only: [:new, :create, :destroy]
  resources :microposts, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]
  resources :patients
  resources :hlas, only: [:index]
  resources :locus_as, only: [:new, :create], controller: :hlas
  resources :locus_a, only: [:edita, :update], controller: :hlas
  resources :locus_bs, only: [:new, :create], controller: :hlas
  resources :locus_b, only: [:editb, :update], controller: :hlas
  resources :locus_cs, only: [:new, :create], controller: :hlas
  resources :locus_c, only: [:editc, :update], controller: :hlas

  root  'static_pages#top'
  match '/help',    to: 'static_pages#help',    via: 'get'
  match '/about',   to: 'static_pages#about',   via: 'get'
  match '/contact', to: 'static_pages#contact', via: 'get'
  match '/signup',  to: 'users#new',            via: 'get'
  match '/signin',  to: 'sessions#new',         via: 'get'
  match '/signout', to: 'sessions#destroy',     via: 'delete'

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
