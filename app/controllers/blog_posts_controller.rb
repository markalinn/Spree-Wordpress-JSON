class BlogPostsController < Spree::BaseController
  def index
    #@posts = BlogPost.find(:all, :params => {:json => 1, :p => 7464})
     @posts =[]
     @authors = []
     @categories = []
     base_url = WORDPRESS_CONFIG['url']

     blog_url = "#{base_url}?json=1&author=#{params[:author]}&page=#{params[:page]}"
     blog_resp = Net::HTTP.get_response(URI.parse(blog_url))
     blog_data = blog_resp.body
     blog_hash = ActiveSupport::JSON.decode(blog_data)
     blog = OpenStruct.new(blog_hash)
     @posts = blog.posts

     authors_url = "#{base_url}?json=get_author_index&page=#{params[:page]}"
     authors_resp = Net::HTTP.get_response(URI.parse(authors_url))
     authors_data = authors_resp.body
     authors_hash = ActiveSupport::JSON.decode(authors_data)
     blog_authors = OpenStruct.new(authors_hash)
     @authors = blog_authors.authors

     categories_url = "#{base_url}?json=get_category_index&page=#{params[:page]}"
     categories_resp = Net::HTTP.get_response(URI.parse(categories_url))
     categories_data = categories_resp.body
     categories_hash = ActiveSupport::JSON.decode(categories_data)
     blog_categories = OpenStruct.new(categories_hash)
     @categories = blog_categories.categories

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
