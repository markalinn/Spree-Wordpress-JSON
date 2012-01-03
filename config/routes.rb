Rails.application.routes.draw do
  # Add your extension routes here
  resources :blog_posts do
    member do
      post :add_comment
    end    
  end
  resources :blog_authors
end
