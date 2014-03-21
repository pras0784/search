module ApplicationHelper
  def parse_keyword
    CGI::escape params[:k].to_s
  end

  def wikipedia_url
    "http://en.wikipedia.org/w/index.php?title=Special%3ASearch&profile=default&search=#{parse_keyword}&fulltext=Search"
  end

  def rotten_tomatoes_url
    "http://www.rottentomatoes.com/search/?search=#{parse_keyword}&sitesearch=rt"
  end
end
