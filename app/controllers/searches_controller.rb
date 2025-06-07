class SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    @model = params[:model]
    @keyword = params[:keyword]
    @search_type = params[:search_type]
    
    if @model == "User"
      @records = User.search(@keyword, @search_type)
    elsif @model == "Book"
      @records = Book.search(@keyword, @search_type)
    else 
      @records = []
    end 
  end 
end
