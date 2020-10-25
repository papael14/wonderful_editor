class Api::V1::ArticleSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at
  belongs_to :user, serializer: Api::V1::UserSerializer
end
