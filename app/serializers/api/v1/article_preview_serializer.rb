# class ArticlePreviewSerializer < ActiveModel::Serializer
#   # attributes :title
#   # belongs_to :user
#   # has_many :article_likes
#   # has_many :comments
# end

class Api::V1::ArticlePreviewSerializer < ActiveModel::Serializer
  attributes :id, :title, :updated_at
  belongs_to :user, serializer: Api::V1::UserSerializer
end
