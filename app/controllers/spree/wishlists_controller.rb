# frozen_string_literal: true

class Spree::WishlistsController < Spree::BaseController
  include Spree::Core::ControllerHelpers::Order
  helper 'spree/products'

  before_action :find_wishlist, only: %i[destroy show update edit]

  respond_to :html

  def new
    @wishlist = Spree::Wishlist.new
    respond_with(@wishlist)
  end

  def index
    @wishlists = spree_current_user.wishlists
    respond_with(@wishlist)
  end

  def edit
    respond_with(@wishlist)
  end

  def update
    @wishlist.update wishlist_attributes
    respond_with(@wishlist)
  end

  def show
    respond_with(@wishlist)
  end

  def default
    @wishlist = spree_current_user.wishlist
    respond_with(@wishlist) do |format|
      format.html { render :show }
    end
  end

  def create
    @wishlist = Spree::Wishlist.new wishlist_attributes
    @wishlist.user = spree_current_user
    @wishlist.save
    respond_with(@wishlist)
  end

  def destroy
    @wishlist.destroy
    respond_with(@wishlist) do |format|
      format.html { redirect_to account_path }
    end
  end

  def mini
    if spree_current_user.present?
      @wishlist = spree_current_user.wishlist

      respond_to do |format|
        format.json do
          render json: {
            link: wishlist_url(@wishlist),
            count: Spree::WishedProduct.where('wishlist_id', @wishlist.id).count
          }
        end
      end
    else
      respond_to do |format|
        format.json do
          render json: {
            link: '#',
            count: 0
          }
        end
      end
    end
  end

  private

  def wishlist_attributes
    params.require(:wishlist).permit(:name, :is_default, :is_private)
  end

  # Isolate this method so it can be overwritten
  def find_wishlist
    @wishlist = Spree::Wishlist.find_by_access_hash!(params[:id])
  end
end
