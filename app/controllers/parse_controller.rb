class Parse
	attr_reader :data

	def initialize(owner_id, count, offset)
		@owner_id = owner_id
		@count = count
		@offset = offset || 0

		@data = get_vk_posts
	end

	def get_vk_posts
	  require 'vkontakte_api'

	  vk = VkontakteApi::Client.new

	  vk.wall.get owner_id: @owner_id, count: @count, offset: @offset
	end

	def filter_text(text)
		arr = text.split("<br>")
		title = arr.delete_at 0
		post = arr.join("<br>")

		return title, post
	end

	def get_photos(attachments, post_id)
	  photos = Array.new
	  attachments.each do |a|
	    next unless a.is_a? Hashie::Mash and a.key? 'photo'
	    photos.push PhotoDraft.create :src => a.photo.src, :src_big => a.photo.src, :post_id => post_id
	  end
	  photos
	end
end

class ParseController < ApplicationController
  
  #disable protect from forgery
  protect_from_forgery

  def index
  end

  def parse
	p = Parse.new params[:owner_id], params[:count], params[:offset]

	@data = p.data

	@data.each do |d|
		next unless d.is_a? Hashie::Mash and d.key? 'text' and d.text.length > 500

		@title, @text = p.filter_text d.text
		post = PostDraft.create :title => @title, :text => @text

		@photos = p.get_photos d.attachments, post.id
	end
  end

end