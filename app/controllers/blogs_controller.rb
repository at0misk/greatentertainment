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
			redirect_to '/' and return
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
		@blogs = Blog.where(user_id: session[:user_id])
	end
	def update
		@blog = Blog.find(params['id'])
		if @blog.update(blog_params)
		end
		redirect_to "/blogs/#{@blog.id}"
	end
	def destroy
		@blog = Blog.find(params['id'])
		Blog.find(params['id']).destroy
		redirect_to "/blogs"
	end
	def index
		@blogs = Blog.all
	end
end
