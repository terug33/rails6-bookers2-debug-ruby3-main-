class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books
  has_many :post_comments, dependent: :destroy 
  has_many :favorites, dependent: :destroy
  has_one_attached :profile_image

  #自分がフォローしているユーザー
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :followings, through: :active_relationships, source: :followed

  #自分をフォローしているユーザー
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: {maximum:50}

  
  
  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end

  #フォロー機能
  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end 

  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end 

  def following?(other_user)
    followings.include?(other_user)
  end 

  #検索機能
  def self.search_for(content, method)
    if method == 'perfect_match'
      User.where('name LIKE ?', content)
    elsif method == 'starts_with'
      User.where('name LIKE ?', content + '%')
    elsif method == 'ends_with'
      User.where('name LIKE ?', '%' + content)
    else 
      User.where('name LIKE ?', '%' + content + '%')
    end
  end 
 
end
