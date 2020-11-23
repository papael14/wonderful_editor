module Api::V1
  class ArticlesController < BaseApiController
    # before_action :set_article, only: [:show, :update, :destroy]
    before_action :authenticate_user!, only: [:create, :update, :destroy]

    def index
      articles = Article.order(updated_at: :desc)
      render json: articles, each_serializer: Api::V1::ArticlePreviewSerializer
    end

    def show
      # article = current_user.articles.find(params[:id])
      article = Article.find(params[:id])
      render json: article
    end

    def create
      article = current_user.articles.create!(article_params)
      render json: article
    end

    def update
      article = current_user.articles.find(params[:id])
      article.update!(article_params)
      render json: article
    end

    def destroy
      article = current_user.articles.find(params[:id])
      article.destroy!
    end

    private

      def set_article
        # article = current_user.articles.find(params[:id])
      end

      def article_params
        params.require(:article).permit(:title, :body)
      end
  end
end

# 作成中の試行錯誤メモ

# def show
#   # article = Article.find(params[:id])
#   render json: article
#   # render json: article, each_serializer: Api::V1::ArticleSerializer
#   # each_serializerでSerializerを指定しなくても同じ階層のArticleSerializerから取得する
# end

# UserテーブルとArticleテーブルの紐付けは終わっているので
# controllerではcurrent_userの下にarticleを作成すればOK
# def create
#   article = Article.new(
#     title: params[:title],
#     body: params[:body],
#     user_id: params[:user_id],
#   )
#   article.save!
#   article = Article.find(Article.last.id)
#   render json: article
# end

# module Api::V1
#   class ArticlesController < BaseApiController
#     #before_action :set_article, only: [:show, :update, :destroy]

#     # def default_serializer_options
#     #   {root: false}
#     # end

#     def index
#       # @articles = Article.order("updated_at DESC")
#       # render json: @articles
#       articles = Article.order(updated_at: :desc)
#       render json: articles, each_serializer: Api::V1::ArticlePreviewSerializer
#     end

#     def show
#       # render json: @article
#     end

#     def create
#       @article = Article.new(
#         title: params[:title],
#         body: params[:body],
#         status: params[:status],
#         user_id: params[:user_id],
#       )
#       @article.save!
#       # @article = Article.new(article_params)

#       # if @article.save
#       #   render :show, status: :created, location: @article
#       # else
#       #   render json: @article.errors, status: :unprocessable_entity
#       # end
#     end

#     def update
#       if @article.update(article_params)
#         render :show, status: :ok, location: @article
#       else
#         render json: @article.errors, status: :unprocessable_entity
#       end
#     end

#     def destroy
#       @article.destroy
#     end

#     private

#       # Use callbacks to share common setup or constraints between actions.
#       def set_article
#         @article = Article.find(params[:id])
#       end

#       # Only allow a list of trusted parameters through.
#       def article_params
#         params.require(:article).permit(:title, :body, :status, :user_id)
#       end
#   end
# end
