Rails.application.routes.draw do
	root 'sessions#new'
	post 'users' => 'users#create'
	post 'sessions' => 'sessions#create'
	get '/requests/:id' => 'users#requests'
	get '/request_chat/:id' => 'users#request_chat'
	post 'topics' => 'topics#create'
	get '/topics/:id' => 'topics#view'
	post '/messages' => 'messages#create'
	# ALL other routes must go above this --
	resources :users, param: :username, :path => '/'
	mount ActionCable.server => '/cable'
  	# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
