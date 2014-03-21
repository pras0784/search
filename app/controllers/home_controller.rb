require 'open-uri'
class HomeController < ApplicationController
  def index
    @imdb = []
    search_imdb(params[:k])
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

  private

  def search_imdb(key)
    #mofied scraper for IMDB.com
    key = CGI::escape key.to_s

    html = Nokogiri::HTML(open("http://imdb.com/find?q=#{key}&s=all"))
    html.search('.findSection').each do |el|

      header = el.search('.findSectionHeader').text()
      results = {
        header => []
      }

      el.search('.findResult').each do |item|
        img = item.at_css('.primary_photo img').attribute('src').content rescue nil
        title = item.at_css('.result_text').text()
        url = item.at_css('.result_text a').attribute('href').content
        results[header] << {
          img: img,
          title: title,
          url: url
        }
      end

      @imdb << results
    end
  end
end
