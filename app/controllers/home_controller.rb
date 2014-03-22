require 'open-uri'
class HomeController < ApplicationController
  include Scraper

  def index
    @imdb = []
    @wikipedia = []
    @rtomatoes = []
    if params[:k].present?
      search_imdb(params[:k])
      search_wikipedia(params[:k])
      search_rt(params[:k])
    end
  end


  def suggest
    #This is for the API of getting json through the API of IMDB
    #link: http://lab.abhinayrathore.com/imdb_suggest/
    #

    key = CGI::escape params[:term].to_s
    results = open('http://lab.abhinayrathore.com/imdb_suggest/suggest.php?term=' + key)
    results = JSON.parse(results.string)
    render json: results
  end

  def proxy_img
    #Proxy route for image to avoid broken images
    url = URI.parse params[:url]
    result = Net::HTTP.get_response(url)
    send_data result.body, type: result.content_type, disposition: 'inline'
  end

end
