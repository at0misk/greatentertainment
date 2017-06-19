class PhotosController < ApplicationController
	def allow
		@photo = Photo.find(params['photo_id'])
		@photo.update_attribute(:allowed, true)
		redirect_back(fallback_location: "/gallery/edit/#{@photo.user.username}")
	end
	def remove
		@photo = Photo.find(params['photo_id'])
		@photo.update_attribute(:allowed, false)
		redirect_back(fallback_location: "/gallery/edit/#{@photo.user.username}")
	end
	def destroy
		@photo = Photo.find(params['photo_id'])
		@username = @photo.user.username
		@photo.destroy
		redirect_back(fallback_location: "/gallery/edit/#{@username}")
	end
end
