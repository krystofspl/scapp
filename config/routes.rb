Scapp::Application.routes.draw do
  root :to => "home#index"
  get '/dashboard' => 'home#dashboard', as: :dashboard

  # help controller
  get '/help/:locale/index' => 'helps#index'
  get '/help/:locale/:theme' => 'helps#show', as: 'show_help'
  get '/help_modal/:locale/:theme' => 'helps#show_ajax', as: 'show_modal_help'

  resources :exercises, except: [:show,:edit,:update,:destroy] do
    collection do
      get 'list_small' => 'exercises#list_small'
    end
  end
  get '/exercises/:exercise_code(/v/:exercise_version)' => 'exercises#show', :as => :exercise
  get '/exercises/:exercise_code(/v/:exercise_version)/edit(:exercise_step_id)' => 'exercises#edit', :as => :edit_exercise
  get '/exercises/:exercise_code(/v/:exercise_version)/clone' => 'exercises#clone', :as => :clone_exercise
  patch '/exercises/:exercise_code(/v/:exercise_version)' => 'exercises#update', :as => :update_exercise
  delete '/exercises/:exercise_code(/v/:exercise_version)' => 'exercises#destroy', :as => :destroy_exercise

  get '/exercises/:exercise_code(/v/:exercise_version)/filterrific_setups' => 'exercises#filterrific_setups'
  get '/exercises/:exercise_code(/v/:exercise_version)/filterrific_measurements' => 'exercises#filterrific_measurements'

  get '/exercises/:exercise_code(/v/:exercise_version)/steps' => 'exercise_steps#index', :as =>:exercise_steps
  post '/exercises/:exercise_code(/v/:exercise_version)/steps' => 'exercise_steps#create', :as =>:create_exercise_step
  patch '/exercises/:exercise_code(/v/:exercise_version)/steps' => 'exercise_steps#update', :as =>:update_exercise_step
  get '/exercises/:exercise_code(/v/:exercise_version)/steps/new' => 'exercise_steps#new', :as =>:new_exercise_step
  get '/exercises/:exercise_code(/v/:exercise_version)/steps/edit' => 'exercise_steps#edit', :as => :edit_exercise_step
  post '/exercises/:exercise_code(/v/:exercise_version)/steps/update_row_order' => 'exercise_steps#update_row_order', :as =>:update_row_order_exercise_steps
  delete '/exercises/:exercise_code(/v/:exercise_version)/steps' => 'exercise_steps#destroy', :as =>:destroy_exercise_step

  resources :exercise_bundles do
    member do
      get 'edit_exercises' => 'exercise_bundles#edit_exercises'
      get 'edit_exercises/add/:exercise_code(/v/:exercise_version)' => 'exercise_bundles#add_exercise', :as => :bundle_add_exercise
      get 'edit_exercises/remove/:exercise_code(/v/:exercise_version)' => 'exercise_bundles#remove_exercise', :as => :bundle_remove_exercise
    end
  end

  resources :exercise_setups do
    member do
      get 'clone' => 'exercise_setups#clone', :as => :clone
      post 'clone' => 'exercise_setups#create', :as => :save_clone
    end
  end

  resources :exercise_measurements do
    member do
      get 'clone' => 'exercise_measurements#clone', :as => :clone
      post 'clone' => 'exercise_measurements#create', :as => :save_clone
    end
  end

  resources :exercise_images, only: [:destroy]

  resources :units

  resources :exercise_realization_setups

  resources :exercise_set_realization_setups

  resources :payments

  resources :training_lesson_realizations, except: [:index], path: 'scheduled_lessons' do
    resources :attendances do
      collection do
        get 'fill' => 'attendances#fill'
        post 'fill' => 'attendances#save_fill'
        get 'calc_payment' => 'attendances#calc_payment'
        post 'calc_payment' => 'attendances#save_calc_payment'
      end
    end

    resources :present_coaches

    resources :variable_field, only: [], path: 'vf' do
      member do
        get 'fill_measurements' => 'variable_fields#scheduled_lesson_vfm_fill'
        post 'fill_measurements' => 'variable_fields#scheduled_lesson_vfm_fill_save'
      end

      collection do
        get 'new_measurement_vf_select' => 'variable_fields#scheduled_lesson_add_measurements_vf_select'
      end
    end

    resources :exercise_realizations do
      collection do
        post 'update_row_order' => 'exercise_realizations#update_row_order'
        get 'show_short' => 'exercise_realizations#show_short'
        get 'list_summary' => 'exercise_realizations#list_summary'
        get 'list_exercises' => 'exercise_realizations#list_exercises'
        get 'list_exercise_realizations' => 'exercise_realizations#list_exercise_realizations'
        get 'list_exercise_setups' => 'exercise_realizations#list_exercise_setups'
        get 'list_exercise_realization_setups' => 'exercise_realizations#list_exercise_realization_setups'
        get 'edit_setups' => 'exercise_realizations#edit_setups'
        get 'edit_sets' => 'exercise_realizations#edit_sets'
        get 'list_exercise_set_realizations' => 'exercise_realizations#list_exercise_set_realizations'
      end
    end

    resources :exercise_set_realizations do
      collection do
        post 'update_row_order' => 'exercise_set_realizations#update_row_order'
        get 'edit_set_setups' => 'exercise_set_realizations#edit_set_setups'
        get 'list_exercise_set_setups' => 'exercise_set_realizations#list_exercise_set_setups'
        get 'list_exercise_set_realization_setups' => 'exercise_set_realizations#list_exercise_set_realization_setups'
      end
    end

    resources :favorite_plans do
      collection do
        post 'copy_favorite_to_plan' => 'favorite_plans#copy_favorite_to_plan'
      end
    end

    member do
      get 'close'
      get 'cancel'
      get 'reopen'
      get 'excuse'
      get 'sign_in'
      get 'sign_in/:user_id' => 'training_lesson_realizations#sign_in', as: :sign_in_user
      get 'excuse/:user_id' => 'training_lesson_realizations#excuse', as: :excuse_user
    end
  end

  resources :regular_training_lesson_realization ,controller: 'training_lesson_realizations', path: 'scheduled_lessons' do
    resource :attendances, only: [:show, :create, :update]

    resources :present_coaches
  end

  resources :individual_training_lesson_realization, controller: 'training_lesson_realizations', path: 'scheduled_lessons' do
    resource :attendances, only: [:show, :create, :update]

    resources :present_coaches

    collection do
      post '/' => 'training_lesson_realizations#create', as: ''
    end
  end

  resources :currencies

  resources :vats

  resources :regular_trainings do
    resources :training_lesson_realizations, only: [:index], path: 'scheduled_lessons'
    resources :training_lessons
    resources :coach_obligations
    resources :attendances, only: [:index] do
      collection do
        get 'player/:user_id' => 'attendances#player_attendance', as: 'player'
      end
    end

    member do
      get 'schedule_trainings' => 'regular_trainings#schedule_trainings', as: :schedule_trainings
      post 'schedule_trainings' => 'regular_trainings#save_scheduled_trainings', as: :save_scheduled_trainings
    end
  end

  resources :variable_fields do
    resources :variable_field_measurements, only: [:new, :create]
  end
  post '/variable_fields/add_category', to: 'variable_fields#add_category', as: 'variable_fields_add_new_category'

  resources :variable_field_categories

  resources :variable_field_user_levels

  resources :variable_field_sports

  resources :variable_field_optimal_values

  resources :variable_field_measurements

  resources :user_relations do
    member do
      get 'change_status/:status' => 'user_relations#change_status', :as => :change_status
    end

    collection do
      get 'request' => 'user_relations#new_request', :as => :new_request
      post 'request' => 'user_relations#create_request', :as => :create_request
    end
  end

  resources :organizations

  resources :user_groups do
    member do
      post 'add_user' => 'user_groups#add_user', :as => :add_user
      delete 'remove_user/:user_id' => 'user_groups#remove_user', :as => :remove_user
    end
  end

  # static routes
  get '/static/:action', to: 'static#:action'

  devise_for :users, only: :sessions, controllers: { sessions: 'sessions' }, path: ''
  devise_scope :user do
    get '/sign_out' => 'sessions#destroy', :as => :destroy_user_session_get
  end
  devise_for :users, only: :registrations, controllers: { registrations: 'registrations' }, path: '', path_names: {edit: 'edit_profile', cancel: 'cancel_profile'}
  devise_for :users, only: :passwords, controllers: { passwords: 'passwords' }, path: ''

=begin
  devise_for :users, skip: [:sessions, :registrations], as: 'user' do
    get '/signin' => 'sessions#new', :as => :new_user_session
    post '/signin' => 'sessions#create', :as => :user_session
    delete '/signout' => 'sessions#destroy', :as => :destroy_user_session
    get '/signout' => 'sessions#destroy', :as => :destroy_user_session_get

    get 'signup' => 'registrations#new', :as => :new_user_registration
    post 'signup' => 'registrations#create', :as => :user_registration
    get 'edit_profile' => 'registrations#edit', :as => :edit_user_registration
    get 'cancel_profile' => 'registrations#cancel', :as => :cancel_user_registration
    patch 'edit_profile' => 'registrations#update'
    put 'edit_profile' => 'registrations#update'
    delete 'edit_profile' => 'registrations#destroy'
  end

  devise_for :users, :controllers => :passwords do
    get 'new' => 'passwords#new'
    post 'create' => 'passwords#create'
  end
=end
  resources :users do
    collection do
      post 'email_hinter' => 'users#email_hinter'
    end

    member do
      get 'set_roles' => 'users#set_roles'
      patch 'set_roles' => 'users#set_roles_save'
    end

    resources :variable_fields, only: [] do
      collection do
        get '/' => 'variable_fields#user_variable_fields'
      end
      member do
        get 'graph' => 'variable_fields#user_variable_graph'
        get 'table' => 'variable_fields#user_variable_table'
        get 'detail' => 'variable_fields#user_variable_field_detail'
        get 'add_measurement' => 'variable_field_measurements#new_for_user'
        post 'add_measurement' => 'variable_field_measurements#create_for_user'
      end
    end

    resources :user_groups, only: [], path: 'groups' do
      collection do
        get '/' => 'user_groups#user_in'
      end
    end

    resources :user_relations, only: [], path: 'relations' do
      collection do
        get '/' => 'user_relations#user_has'
      end
    end

    get 'trainings' => 'trainings#user_overview'

    resources :exercises, only: [], path: 'exercises' do
      collection do
        get '/' => 'exercises#user_exercises'
      end
    end

    resources :exercise_bundles, path: 'exercise_bundles' do
      collection do
        get '/' => 'exercise_bundles#user_exercise_bundles'
      end
    end

  end

end