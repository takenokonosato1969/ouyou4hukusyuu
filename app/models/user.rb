class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_one_attached :profile_image
  
  has_many :follower, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy #フォローしている人の取得
  has_many :followed, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy #フォローされている人の取得
  
  # ここではforeign_keyで繋いだところの定義をおこなう。
  has_many :following_user, through: :follower, source: :followed #自分がフォロー
  # following_user:中間テーブルを通し、followedモデルのフォローされる側を取得
  has_many :follower_user, through: :followed, source: :follower #自分をフォロー
  # follower_user:中間テーブルを通し、followerモデルのフォローする側を取得

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: { maximum: 50 }
  
  
  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end
  
  #ユーザーをフォロー
  def follow(user_id)
    follower.create(followed_id: user_id)
  end
  
  #フォローを外す
  def unfollow(user_id)
    follower.find_by(followed_id: user_id).destroy
  end
  
  #フォローしてればtrueを返す
  def following?(user)
    following_user.include?(user)
  end
  
  # 検索分岐のコード
  # 文字検索をしたい時はLIKE句を使用する
  # %はワイルドカード
  def self.search_for(content,method)
    if method == "perfect"
        User.where(name: content)
    elsif method == "forward"
        User.where("name LIKE ?", content + "%")
    elsif method == "backward"
        User.where("name LIKE ?", "%" + content)
    else
        User.where("name LIKE ?", "%" + content + "%")
    end
  end
end
