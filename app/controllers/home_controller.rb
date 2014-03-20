require 'open-uri'
class HomeController < ApplicationController

  def suggest
    #This is for the API of getting json through the API of IMDB
    #link: http://lab.abhinayrathore.com/imdb_suggest/
    #

    key = CGI::escape params[:term].to_s
    results = open('http://lab.abhinayrathore.com/imdb_suggest/suggest.php?term=' + key)
    results = JSON.parse(results.string)
    render json: results
  end
end
