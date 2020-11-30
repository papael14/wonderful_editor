module Api::V1
  class Articles::DraftsController < BaseApiController
    before_action :authenticate_user!

    def index
      articles = Article.draft.where(user_id: current_user.id).order(updated_at: :desc)
      render json: articles, each_serializer: Api::V1::ArticlePreviewSerializer
    end

    def show
      article = Article.draft.where(user_id: current_user.id).find(params[:id])
      render json: article, serializer: Api::V1::ArticleSerializer
    end

    private

      def article_params
        params.require(:article).permit(:title, :body, :status)
      end
  end
end
