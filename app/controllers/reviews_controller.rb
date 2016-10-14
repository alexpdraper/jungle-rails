class ReviewsController < ApplicationController

  before_filter :require_login

  def create
    @product = Product.find(params[:product_id])
    @review = @product.reviews.new(review_params)
    @review.user = current_user

    if @review.save
      redirect_to product_path(@product)
    else
      render product_path(@product)
    end
  end

  private
    def review_params
      params.require(:review).permit(:rating, :description)
    end

    def require_login
      unless current_user
        flash[:error] = 'You must be logged in to review products'
        redirect_to login_path
      end
    end

end
