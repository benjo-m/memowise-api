class UsersController < ApplicationController
  def index
    @users = User.all

    render json: @users
  end

  def get_decks
    @user = User.find(params[:id])

    render json: @user.decks
  end
end
