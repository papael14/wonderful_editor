module Api::V1
  class ArticlesController < BaseApiController
    before_action :set_article, only: [:show, :update, :destroy]

    # def default_serializer_options
    #   {root: false}
    # end

    def index
      # @articles = Article.order("updated_at DESC")
      # render json: @articles
      articles = Article.order(updated_at: :desc)
      render json: articles, each_serializer: Api::V1::ArticlePreviewSerializer
    end

    def show
      # render json: @article
    end

    def create
      @article = Article.new(
        title: params[:title],
        body: params[:body],
        status: params[:status],
        user_id: params[:user_id],
      )
      @article.save!
      #      @article = Article.new(article_params)

      # if @article.save
      #   render :show, status: :created, location: @article
      # else
      #   render json: @article.errors, status: :unprocessable_entity
      # end
    end

    def update
      if @article.update(article_params)
        render :show, status: :ok, location: @article
      else
        render json: @article.errors, status: :unprocessable_entity
      end
    end

    def destroy
      @article.destroy
    end

    private

      # Use callbacks to share common setup or constraints between actions.
      def set_article
        @article = Article.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def article_params
        params.require(:article).permit(:title, :body, :status, :user_id)
      end
  end
end
