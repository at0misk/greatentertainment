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
	get '/blogs' => 'blogs#index'
	get '/blogs/edit/:id' => 'blogs#edit'
	get '/blogs/new' => 'blogs#new'
	post 'blogs' => 'blogs#create'
	post 'blogs/destroy' => 'blogs#destroy'
	patch '/blogs/:id' => 'blogs#update'
	get '/blogs/:id' => 'blogs#view'
	get '/subscriptions' => 'subscriptions#index'
	get '/subscriptions/destroy/:id' => 'subscriptions#destroy'
	get '/subscriptions/new' => 'subscriptions#new'
	get '/subscriptions/:id' => 'subscriptions#subscribe'
	post '/subscriptions' => 'subscriptions#create'
	get '/cruises/new/:id' => 'cruises#new'
	post '/cruises' => 'cruises#create'
	get '/cruises/:id' => 'cruises#view'
	get '/specials/edit/:username' => 'specials#edit'
	get '/specials/all_specials/:username' => 'specials#user_index'
	get '/specials/new/:username' => 'specials#new'
	post '/specials' => 'specials#create'
	get '/specials/destroy/:id' => 'specials#destroy'
	get '/specials/feature/:id' => 'specials#feature'
	get '/specials/:user_id/:id' => 'specials#view'
	patch '/specials' => 'specials#update'
	post 'contact' => 'users#contact'
	get '/gallery_upload/:username' => 'users#gallery_upload'
	get '/gallery/edit/:username' => 'users#gallery_edit'
	get '/gallery/:username' => 'users#gallery'
	post '/gallery_upload' => 'users#photo_create'
	patch '/gallery_edit/:id' => 'users#gallery_update'
	patch '/photo_allow' => 'photos#allow'
	patch '/photo_remove' => 'photos#remove'
	post '/photo_destroy' => 'photos#destroy'
	get '/logout' => 'sessions#logout'
	post '/call' => 'users#call'
	get '/connect/:sales_number' => 'users#connect'
	get '/quote' => 'sessions#quote'
	# ALL other routes must go above this --
	resources :users, param: :username, :path => '/'
  	# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
