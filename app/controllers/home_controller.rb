require 'open-uri'
class HomeController < ApplicationController
  def index
    @imdb = []
    @wikipedia = []
    @rt = []
    search_imdb(params[:k])
    search_wikipedia(params[:k])
    search_rt(params[:k])
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

  def search_rt(key)
    #scraping rotten tomatoes site
    key = CGI::escape key.to_s
    html = Nokogiri::HTML(open("http://www.rottentomatoes.com/search/?search=#{key}&sitesearch=rt"))
    html.css('#results_all_tab .content_box').each do |el|
      header = el.at_css('.bottom_divider').content
      results = {
        header => []
      }

      el.css('li.media_block').each do |item|
        img = item.at_css('img').attribute('src').content rescue ''
        b_html = item.at_css('.media_block_content')

        b_html.css('a').each do |anc|
          anc.attributes['href'].value = 'http://www.rottentomatoes.com' + anc.attributes['href'].value
        end

        results[header] << {
          img: img,
          html: b_html
        }
      end

      @rt << results
    end
  end

  def search_wikipedia(key)
    #scraping wikipedia
    key = CGI::escape key.to_s

    html = Nokogiri::HTML(open("http://en.wikipedia.org/w/index.php?title=Special%3ASearch&profile=default&search=#{key}&fulltext=Search"))
    html = html.at_css('.mw-search-results')
    if html.present?
      html.search('li').each do |el|
        item = {
          title: el.at_css('.mw-search-result-heading').content,
          url: el.at_css('.mw-search-result-heading a').attribute('href').value,
          desc: el.at_css('.searchresult').content,
          data: el.at_css('.mw-search-result-data').content
        }

        @wikipedia << item
      end
    end
  end
end
