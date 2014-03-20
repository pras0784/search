module ApplicationHelper
  def parse_keyword
    CGI::escape params[:k]
  end
end
