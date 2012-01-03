class BlogPostsController < Spree::BaseController
  def index
    #@posts = BlogPost.find(:all, :params => {:json => 1, :p => 7464})
     @posts =[]
     @authors = []
     @categories = []
     base_url = WORDPRESS_CONFIG['url']

     blog_url = "#{base_url}?json=1"
     if params[:cat]
       blog_url = blog_url + "&cat=#{params[:cat]}"
     end
     if params[:author]
       blog_url = blog_url + "&author=#{params[:author]}"
     end
     blog_url = blog_url + "&page=#{params[:page]}"
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
     @comments = @post.comments

    respond_to do |format|
      format.html # index.html.erb
    end
  end
  
  def add_comment
     base_url = WORDPRESS_CONFIG['url'] + "?json=submit_comment"
     base_url = base_url + "&post_id="
     base_url = base_url + URI.escape(params[:id])
     base_url = base_url + "&name="
     base_url = base_url + URI.escape(params[:comment][:name])
     base_url = base_url + "&email="
     base_url = base_url + URI.escape(params[:comment][:email])
     base_url = base_url + "&url="
     base_url = base_url + URI.escape(params[:comment][:url])
     base_url = base_url + "&content="
     base_url = base_url + URI.escape(params[:comment][:content])
     resp = Net::HTTP.get_response(URI.parse(base_url))
     data = resp.body
     comment = ActiveSupport::JSON.decode(data)
     if comment["status"] == "pending"
       flash[:notice] = 'Your comment is pending approval'
     elsif comment["status"] == "error"
       flash[:notice] = comment["error"]
     else
       flash[:notice] = 'Your comment has been added!'
     end
      respond_to do |format|
        format.html { redirect_to blog_post_url(params[:id]) }
      end
           
  end
end
