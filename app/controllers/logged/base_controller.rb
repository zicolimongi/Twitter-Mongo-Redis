class Logged::BaseController < ApplicationController
  before_action :authenticate_user!
  layout "logged"
end