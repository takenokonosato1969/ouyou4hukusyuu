Rails.application.routes.draw do
  devise_for :users
  root :to =>"homes#top"
  get "home/about"=>"homes#about"

  resources :books do
    resources :book_comments, only: [:create, :destroy]
    resource :favorites, only: [:create, :destroy]
  end

  resources :users, only: [:index,:show,:edit,:update] do
    member do
      get :follows, :followers
    end
      resource :relationships, only: [:create, :destroy]
  end
#   memberオプション
# resources以外の自分で定義したアクションへのルーティングを設定する場合に使用する。
# 同じ場面で使用するものとしてcollectionがあるが、アクションにidを渡したいときは、 memberを使用すること。

# member : アクションにidが渡されるため、id を使用した特定のデータに対するアクションの場合。
# collection　：idを渡さない。id の必要ない全体のデータに対するアクションの場合。
# 上記でmemberを使用しているのは、
# follow・followerアクションが必要かつ、それらにはidが必要だから。
  

end
