class SearchesController < ApplicationController
  before_action :authenticate_user!
  
  def search
    @model = params[:model]#ユーザーかブックか
    @content = params[:content]#検索内容
    @method = params[:method]#どこが一致するか
    if @model == "user"
      @records=User.search_for(@content,@method)
    else
      @records=Book.search_for(@content,@method)
    end
  end
end
