Rails.application.routes.draw do
	root 'sessions#new'
	post 'users' => 'users#create'
	post 'sessions' => 'sessions#create'
	# get '/requests/:id' => 'users#requests'
	# get '/request_chat/:id' => 'users#request_chat'
	# post 'topics' => 'topics#create'
	# post '/topics/destroy' => 'topics#destroy'
	# get '/topics/:id' => 'topics#view'
	# post '/messages' => 'messages#create'
	get '/blogs' => 'blogs#index'
	get '/blogs/edit' => 'blogs#edit'
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
	# get '/cruises/new/:id' => 'cruises#new'
	# post '/cruises' => 'cruises#create'
	# get '/cruises/:id' => 'cruises#view'
	get '/specials/edit/:username' => 'specials#edit'
	get '/specials/all_specials/:username' => 'specials#user_index'
	get '/specials/new/:username' => 'specials#new'
	post '/specials' => 'specials#create'
	get '/specials/destroy/:id' => 'specials#destroy'
	get '/specials/feature/:id' => 'specials#feature'
	get '/specials/unfeature/:id' => 'specials#unfeature'
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
	post '/quote' => 'sessions#quote_process'
	post '/interested' => 'sessions#interested'
	post '/interested/funjet' => 'specials#interested_funjet'
	post '/fj_special' => 'specials#fj_create'
	get '/fj_show' => 'specials#fj_show'
	get '/user_guide' => 'sessions#user_guide'
	post 'mail_subscribers' => 'subscriptions#mail_subscribers'
	get '/commissions' => 'commissions#index'
	get '/commissions/tracker' => 'commissions#tracker'
	get '/admins' => 'users#admins'
	post '/admins' => 'sessions#admins_login'
	get '/admin_dash' => 'users#admin_dash'
	post '/users/search' => 'users#user_search'
	get 'users_found' => 'users#users_found'
	get '/forgot_password' => 'users#forgot_password'
	post '/recover' => 'users#recover'
	get '/admins/edit_user/:id' => 'users#admins_edit_user'
	patch '/admins/:username' => 'users#admins_update'
	get '/admins/user_destroy/:id' => 'users#admins_destroy_user'
	get '/admins/edit_gallery/:id' => 'users#admins_edit_gallery'
	get '/admins/edit_specials/:id' => 'users#admins_edit_specials'
	get '/admins_specials/feature/:id' => 'users#admins_feature'
	get '/admins_specials/unfeature/:id' => 'users#admins_unfeature'
	patch '/admins/gallery_upload/:id' => 'users#admins_gallery_update'
	get 'privacy_policy' => 'sessions#privacy_policy'
	post '/commissions' => 'commissions#create'
	post '/commissions/search' => 'commissions#search'
	post '/commissions/unprocessed_search' => 'commissions#unprocessed_search'
	get '/commissions_found' => 'commissions#commissions_found'
	get '/commissions/process/:id' => 'commissions#process_commission'
	get '/commissions/unprocess/:id' => 'commissions#unprocess'
	get '/commissions/:id' => 'commissions#view'
	get '/register' => 'sessions#register'
	post '/import_users' => 'users#import_users'
	post '/import_commissions' => 'commissions#import_commissions'
	get '/test_scrape' => 'users#test_scrape'
	get '/hawaii/:url' => 'specials#hawaii'
	get '/resources' => 'sessions#resources'
	get '/beta' => 'users#beta_test'
	get '/admins_active_users' => 'users#admins_active_users'
	get '/admins_today_users' => 'users#admins_today_users'
	# ALL other routes must go above this --
	resources :users, param: :username, :path => '/'
  	# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
