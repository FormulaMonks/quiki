class PublishingsController < ApplicationController
  def new
    @version = Page::Version.find params[:page_version_id]
    @page = @version.page
    @publishing = Publishing.new
  end
end