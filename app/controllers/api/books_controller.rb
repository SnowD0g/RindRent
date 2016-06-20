module API
  class BooksController < API::BaseController
    before_action :find_book_by_id, only: [:show, :update, :destroy]

    def index
      books = Book.all
      render json: books, status: :ok
    end

    def show
      render json: @book, status: :ok
    end

    # Some successful responses might  not need to include a response body
    # Ajax responses can be made a lot faster with no response body.
    # render nothing: true, status:204, location: episode oppure una versione ancora più minimale
    # head 204, location: episode

    def create
      book = Book.new(book_params)
      if book.save!
        render json: book, status: :created, location: [:api, book]
      end
    end

    def update
      render json: @book, status: 200 if @book.update!(book_params)
    end

    def destroy
      @book.destroy
      head 204
    end

    protected

    def find_book_by_id
      @book = Book.find(params[:id])
    end

    def book_params
      params.require(:book).permit(:id, :title, :description, :isbn, :note, :cover)
    end
  end
end