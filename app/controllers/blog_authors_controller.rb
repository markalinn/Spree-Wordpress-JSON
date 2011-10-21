class BlogAuthorsController < Spree::BaseController
  def index
    #@posts = BlogPost.find(:all, :params => {:json => 1, :p => 7464})
     base_url = "http://localhost/~marklinn/wordpress/?json=get_author_index"
     url = "#{base_url}&page=#{params[:page]}"
     resp = Net::HTTP.get_response(URI.parse(url))
     data = resp.body
     blog_authors_hash = ActiveSupport::JSON.decode(data)
     blog_authors = OpenStruct.new(blog_authors_hash)
     @authors = blog_authors.authors

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    #@posts = BlogPost.find(:all, :params => {:json => 1, :p => 7464})
     base_url = "http://localhost/~marklinn/wordpress/?json=1&author=" + params[:id]
     url = "#{base_url}&page=#{params[:page]}"
     resp = Net::HTTP.get_response(URI.parse(url))
     data = resp.body
     blog_author_hash = ActiveSupport::JSON.decode(data)
     blog_author = OpenStruct.new(blog_author_hash)
     @author = blog_author.author

    respond_to do |format|
      format.html # index.html.erb
    end
  end
end
