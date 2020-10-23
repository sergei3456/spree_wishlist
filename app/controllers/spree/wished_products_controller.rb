# frozen_string_literal: true

module Spree
  class WishedProductsController < Spree::BaseController
    include Spree::Core::ControllerHelpers::Order
    respond_to :html
    respond_to :json, only: %i[create update]

    def create
      @wished_product = Spree::WishedProduct.new(wished_product_attributes)
      @wishlist = spree_current_user.wishlist

      if @wishlist.include? params[:wished_product][:variant_id]
        @wished_product = @wishlist.wished_products.detect { |wp| wp.variant_id == params[:wished_product][:variant_id].to_i }
      else
        @wished_product.wishlist = spree_current_user.wishlist
        @wished_product.save
      end

      respond_to do |format|
        format.json do
          render json: {
              link: wishlist_url(@wishlist),
              count: Spree::WishedProduct.where('wishlist_id', @wishlist.id).count
          }
        end
      end
    end

    def update
      @wished_product = Spree::WishedProduct.find(params[:id])
      @wished_product.update(wished_product_attributes)

      respond_with(@wished_product) do |format|
        format.html { redirect_to wishlist_url(@wished_product.wishlist) }
      end
    end

    def destroy
      @wished_product = Spree::WishedProduct.find(params[:id])
      @wished_product.destroy

      respond_with(@wished_product) do |format|
        format.html { redirect_to wishlist_url(@wished_product.wishlist), status: :see_other }
      end
    end

    private

    def wished_product_attributes
      params.require(:wished_product).permit(:variant_id, :wishlist_id, :remark, :quantity)
    end
  end
end
