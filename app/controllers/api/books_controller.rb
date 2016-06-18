module API
  class BooksController < API::BaseController
    before_action :find_book_by_id, only: [:show, :update]
    def index
      books = Book.all
      render json: books, status: :ok
    end

    def show
      render json: @book, status: :ok
    end

    def update
    end

    protected

    def find_book_by_id
      @book = Book.find(params[:id])
    end
  end
end