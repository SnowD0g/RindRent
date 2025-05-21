module API
  class LoanedItemsController < API::BaseController
    before_action :find_loaned_item_by_id, only: [:show, :update, :destroy]

    def index
      loaned_items = LoanedItem.all
      render json: loaned_items, status: :ok
    end

    def show
      render json: @loaned_item, status: :ok
    end

    # Some successful responses might  not need to include a response body
    # Ajax responses can be made a lot faster with no response body.
    # render nothing: true, status:204, location: episode oppure una versione ancora più minimale
    # head 204, location: episode

    def create
      loaned_item = LoanedItem.new(loaned_item_params)
      if loaned_item.save!
        render json: loaned_item, status: :created, location: [:api, loaned_item]
      end
    end

    def update
      render json: @loaned_item, status: 200 if @loaned_item.update!(loaned_item_params)
    end

    def destroy
      @loaned_item.destroy
      head 204
    end

    protected

    def find_loaned_item_by_id
      @loaned_item = LoanedItem.find(params[:id])
    end

    def loaned_item_params
      params.require(:loaned_item).permit(:id, :title, :friend_name, :loan_date, :returned, :returned_date)
    end
  end
end