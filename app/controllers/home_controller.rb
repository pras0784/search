require 'open-uri'
class HomeController < ApplicationController
  def index
  end

  def suggest
    key = CGI::escape params[:term].to_s
    results = open('http://lab.abhinayrathore.com/imdb_suggest/suggest.php?term=' + key)
    results = JSON.parse(results.string)
    render json: results
  end
end
