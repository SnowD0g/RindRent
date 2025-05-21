class LoanedItemsController < ApplicationController
  before_action :set_loaned_item, only: [:show, :edit, :update, :destroy, :mark_as_returned]

  # GET /loaned_items
  # GET /loaned_items.json
  def index
    @loaned_items = LoanedItem.all
  end

  # GET /loaned_items/1
  # GET /loaned_items/1.json
  def show
  end

  # GET /loaned_items/new
  def new
    @loaned_item = LoanedItem.new
  end

  # GET /loaned_items/1/edit
  def edit
  end

  # POST /loaned_items
  # POST /loaned_items.json
  def create
    @loaned_item = LoanedItem.new(loaned_item_params)

    respond_to do |format|
      if @loaned_item.save
        format.html { redirect_to @loaned_item, notice: 'Loaned item was successfully created.' }
        format.json { render :show, status: :created, location: @loaned_item }
      else
        format.html { render :new }
        format.json { render json: @loaned_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /loaned_items/1
  # PATCH/PUT /loaned_items/1.json
  def update
    respond_to do |format|
      if @loaned_item.update(loaned_item_params)
        format.html { redirect_to @loaned_item, notice: 'Loaned item was successfully updated.' }
        format.json { render :show, status: :ok, location: @loaned_item }
      else
        format.html { render :edit }
        format.json { render json: @loaned_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /loaned_items/1
  # DELETE /loaned_items/1.json
  def destroy
    @loaned_item.destroy
    respond_to do |format|
      format.html { redirect_to loaned_items_url, notice: 'Loaned item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # PATCH /loaned_items/:id/mark_as_returned
  def mark_as_returned
    if @loaned_item.update(returned: true, returned_date: Date.current)
      flash[:notice] = 'Loaned item was successfully marked as returned.'
    else
      flash[:alert] = 'Could not mark item as returned.'
    end
    redirect_to loaned_items_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_loaned_item
      @loaned_item = LoanedItem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def loaned_item_params
      params.require(:loaned_item).permit(:title, :friend_name, :loan_date, :returned, :returned_date)
    end
end
