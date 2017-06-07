class BlogsController < ApplicationController
	def new
		@user = User.find(session[:user_id])
	end
	def create
		@user = User.find(session[:user_id])
		@blog = Blog.new(blog_params)
		if @blog.save

		end
		redirect_to "/blogs/#{@user.id}"
	end
	def blog_params
		params.require(:blog).permit(:title, :content, :user_id)
	end
	def view
		@blogs = Blog.where(user_id: params['id'])
	end
	def edit
		@blogs = Blog.where(user_id: params['id'])
	end
	def update
		@blog = Blog.find(params['id'])
		if @blog.update(blog_params)
		end
		redirect_to "/blogs/#{@blog.user.id}"
	end
	def destroy
		@blog = Blog.find(params['id'])
		Blog.find(params['id']).destroy
		redirect_to "/blogs/#{@blog.user_id}"
	end
end
