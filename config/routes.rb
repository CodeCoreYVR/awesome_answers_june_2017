Rails.application.routes.draw do
  # using the defaults argument, we can provide a set of options
  # that will act as the new defaults for the nested routes.
  # In this case, every route inside of the api namespace will
  # render json by default instead of html.
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      # /api/v1/questions
      resources :questions, only: [:index, :show, :create]
      resources :tokens, only: [:create]
    end
  end

  match "/delayed_job" => DelayedJobWeb, anchor: false, via: [:get, :post]
  # the `namespace` feature of Rails routes will add the name space as section
  # of the URL so in this case all routes defined within this `admin` namespace
  # will be prepended with `/admin` so the url index for `dahsbaord` will be:
  # /admin/dashboard
  # also note that the resources for controllers defined within the namespace
  # will be expected to be in a folder with the same name as the `namespace`
  # which is `admin` in this case. So dashboard_controller.rb must be located
  # in a subfolder called `admin` within `/app/controllers`
  namespace :admin do
    resources :dashboard, only: :index
    resources :survey_questions, only: [:index, :new, :create]
  end

  # Note that we are not using `resources` in this case, because
  # there should always only be one session. Singular resource will
  # not create any routes that requires id. Instead, it expects that
  # it will always be working with the same resource.

  # Even though resource is singular and we gave an argument (i.e. :session)
  # that is singular, it still expects the controller to be named in plural
  # (i.e. SessionsController)
  resource :session, only: [:new, :create, :destroy]
  resources :users, only: [:new, :create, :show]

  resources :user_maps, only: [:index]

  # Here we want vote routes to be nested inside of answers without
  # creating any routes for the answers themselves. This is why we provide
  # `resources :answers` with the only argument with an empty array.

  # the `shallow: true` argument will only nested routes for those that require it
  # such `:create`, `:index` and `:new`. All other routes that don't require the
  # parent resource will be by themselves
  resources :answers, only: [], shallow: true do
    resources :votes, only: [:create, :destroy, :update]
    # /answers/:answer_id/votes
    # /votes/:id
  end

  # POST /questions/5/answers

  # resources :questions, except: [:delete]
  # resources :questions, only: [:index, :show
  resources :questions do
    resources :likes, only: [:create, :destroy]
    resources :answers, only: [:create, :destroy]
    # We can nest routes. When doing so, rails will generate the route prefix
    # with the parent resources in this `/questions/:question_id`

    # Example routes that are generated by the above:
    # /questions/:question_id/answers(.:format)
    # /questions/:question_id/answers/new(.:format)

    # When using a route helper method of a nested route such
    # as question_answers_path (or question_answers_url), you
    # must provide an id or record of the parent resources
    # (e.g. `question_answers_path(@question)`)


    resources :publishings, only: :create
  end
  # resources :questions will generate all CRUD routes just like
  # we wrote below for a given resource name. Make sure that you write
  # plural `resources` and also pluralize the resource name (i.e. :questions)

  # post('questions/', to: 'questions#create', as: :questions)
  # get('questions/new', to: 'questions#new', as: :new_question)
  # get('questions/:id', to: 'questions#show', as: :question)
  # get('questions/:id/edit', to: 'questions#edit', as: :edit_question)
  # patch('questions/:id', to: 'questions#update')
  # get('questions/', to: 'questions#index')
  # delete('questions/:id', to: 'questions#destroy')

  # The order of routes matter. The first route matches is the one that
  # is taken. Make sure that more specific appear before more broad routes
  # (e.g. `questions/new` should always appear before `questions/:id`)

  # this rules defines the following: when we recieve a `GET` request to `/`
  # which is the home page, send the request to the `Welcome` controller and
  # `index` action within that controller. An action is a public instance method
  # that is defined within the controller.
  # as: :home will generate a URL helper that will gives a view helper method
  # to auto-generate the URL
  # get('/', { to: 'welcome#index', as: :home })

  root 'welcome#index' # this will give you a helper method `root_path` that
                       # will take you to the home page which is welcome/index
                       # in our case

  get('/contact', { to: 'contact#new' })
  # get '/contact', { to: 'contact#new' }
  # get '/contact', to: 'contact#new'

  post('/contact_submit', { to: 'contact#create' })
end
