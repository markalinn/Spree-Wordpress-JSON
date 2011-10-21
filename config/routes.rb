Rails.application.routes.draw do
  # Add your extension routes here
  resources :blog_posts
  resources :blog_authors
end
