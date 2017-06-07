Rails.application.routes.draw do
	root 'sessions#new'
	post 'users' => 'users#create'
	post 'sessions' => 'sessions#create'
	get '/requests/:id' => 'users#requests'
	get '/request_chat/:id' => 'users#request_chat'
	post 'topics' => 'topics#create'
	post '/topics/destroy' => 'topics#destroy'
	get '/topics/:id' => 'topics#view'
	post '/messages' => 'messages#create'
	get '/blogs/edit/:id' => 'blogs#edit'
	get '/blogs/new/:id' => 'blogs#new'
	post 'blogs' => 'blogs#create'
	post 'blogs/destroy' => 'blogs#destroy'
	patch '/blogs/:id' => 'blogs#update'
	get '/blogs/:id' => 'blogs#view'
	# ALL other routes must go above this --
	resources :users, param: :username, :path => '/'
	mount ActionCable.server => '/cable'
  	# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
