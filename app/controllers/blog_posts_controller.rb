class BlogPostsController < Spree::BaseController
  def index
    #@posts = BlogPost.find(:all, :params => {:json => 1, :p => 7464})
     base_url = WORDPRESS_CONFIG['url'] + "?json=1"
     url = "#{base_url}&author=#{params[:author]}&page=#{params[:page]}"
     resp = Net::HTTP.get_response(URI.parse(url))
     data = resp.body
     blog_hash = ActiveSupport::JSON.decode(data)
     blog = OpenStruct.new(blog_hash)
     @posts = blog.posts

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    #@posts = BlogPost.find(:all, :params => {:json => 1, :p => 7464})
     base_url = WORDPRESS_CONFIG['url'] + "?json=1&p=" + params[:id]
     resp = Net::HTTP.get_response(URI.parse(base_url))
     data = resp.body
     blog_hash = ActiveSupport::JSON.decode(data)
     @post = OpenStruct.new(blog_hash["post"])

    respond_to do |format|
      format.html # index.html.erb
    end
  end
end
