class BlogsController < ApplicationController
	def new
		@user = User.find(session[:user_id])
		if @user.permod
		else
			redirect_to '/' and return
		end
	end
	def create
		@user = User.find(session[:user_id])
		@blog = Blog.new(blog_params)
		if @blog.save
		else
	    	flash[:errors] = @blog.errors.full_messages
			redirect_to '/blogs/new' and return
		end
		redirect_to "/blogs/#{@blog.id}"
	end
	def blog_params
		params.require(:blog).permit(:title, :content, :user_id, :author, :image)
	end
	def view
		@blog = Blog.find(params[:id])
	end
	def edit
		@user = User.find(session[:user_id])
		if @user.permod
			@blogs = Blog.all
		else
			redirect_to '/' and return
		end
	end
	def update
		@user = User.find(session[:user_id])
		if @user.permod			
			@blog = Blog.find(params['id'])
			if @blog.update(blog_params)
			end
			redirect_to "/blogs/#{@blog.id}" and return
		else
			redirect_to "/" and return
		end
	end
	def destroy
		@user = User.find(session[:user_id])
		if @user.permod	
			@blog = Blog.find(params['id'])
			Blog.find(params['id']).destroy
			redirect_to "/blogs" and return
		else
			redirect_to "/" and return
		end
	end
	def index
		@blogs = Blog.all.order("created_at DESC")
	end
end
