class RelationshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  def create
    current_user.follow(@user)
    redirect_to request.referer
  end 

  def destroy
    current_user.unfollow(@user)
    redirect_to request.referer 
  end 

  #def followingsはアクション名→ルーティングの#followingsと名前を揃える
  #.followingsはメソッド→モデルの「has_many :followings, through: :active_relationships, source: :followed」と名前を揃える
  def followings
    @users = @user.followings
  end

  def followers 
    @users = @user.followers 
  end

  
  private

  def set_user
    @user = User.find(params[:user_id])
  end 
end
