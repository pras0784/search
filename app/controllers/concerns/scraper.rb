module Scraper
  extend ActiveSupport::Concern

  private
  def search_imdb(key)
    #Scraper for IMDB.com
    #Using this module needs to have an initialized @imdb array instance variable
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
    #Scraper for rotten tomatoes site
    #Using this module needs to have an initialized @rtomatoes array instance variable
    key = CGI::escape key.to_s
    html = Nokogiri::HTML(open("http://www.rottentomatoes.com/search/?search=#{key}&sitesearch=rt"))
    html.css('#results_all_tab .content_box').each do |el|
      header = el.at_css('.bottom_divider').try(:content)
      results = {
        header => []
      }

      el.css('li.media_block').each do |item|
        img = item.at_css('img').attribute('src').content rescue ''
        b_html = item.at_css('.media_block_content')

        b_html.css('a').each do |anc|
          if anc.attributes['href'].try(:value).present?
            anc.attributes['href'].value = 'http://www.rottentomatoes.com' + anc.attributes['href'].value
            anc['target'] = '_blank'
          end
        end

        results[header] << {
          img: img,
          html: b_html
        }
      end

      @rtomatoes << results
    end
  end

  def search_wikipedia(key)
    #Scraper for wikipedia
    #Using this module needs to have an initialized @wikipedia array instance variable
    key = CGI::escape key.to_s

    html = Nokogiri::HTML(open("http://en.wikipedia.org/w/index.php?title=Special%3ASearch&profile=default&search=#{key}&fulltext=Search"))
    html = html.at_css('.mw-search-results')
    if html.present?
      html.search('li').each do |el|
        item = {
          title: el.at_css('.mw-search-result-heading').try(:content),
          url: el.at_css('.mw-search-result-heading a').attribute('href').try(:value),
          desc: el.at_css('.searchresult').try(:content),
          data: el.at_css('.mw-search-result-data').try(:content)
        }

        @wikipedia << item
      end
    end
  end
end
