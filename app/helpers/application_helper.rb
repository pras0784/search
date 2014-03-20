module ApplicationHelper
  def parse_keyword
    CGI::escape params[:k].to_s
  end
end
