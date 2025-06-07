class Book < ApplicationRecord
  belongs_to :user
  has_many :post_comments, dependent: :destroy 
  has_many :favorites, dependent: :destroy
  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  def self.search_for(content, method)
    if method == 'perfect_match'
      Book.where(title: content)
    elsif method == 'starts_with'
      Book.where('title LIKE ?', content + '%')
    elsif method == 'ends_with'
      Book.where('title LIKE ?', '%' + content)
    else 
      Book.where('title LIKE ?', '%' + content + '%')
    end 
  end 
  
end
