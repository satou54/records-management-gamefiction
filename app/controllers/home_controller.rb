class HomeController < ApplicationController
  def index
    puts "------------"
    puts "home#index"
    if user_signed_in?
      puts "ログイン中"
    else
      puts "未ログイン"
    end
  end
end
