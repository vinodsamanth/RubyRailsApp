class BooksController < ApplicationController

  http_basic_authenticate_with name: "ruby", password: "rails", except: [:index, :show]

  def new
    @book = Book.new
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])

    if @book.update(book_params)
      if params[:book][:picture]
        uploaded_io = params[:book][:picture]
        File.open(Rails.root.join('public', 'uploads', "#{@book.id}.jpg"), 'wb') do |file|
          file.write(uploaded_io.read)
        end
      end
      redirect_to @book
    else
      render 'edit'
    end
  end

  def index
    @books = Book.all
  end

  def show
    @book = Book.find(params[:id])
  end

  def create
    @book = Book.new(book_params)

    if @book.save
      if params[:book][:picture]
        uploaded_io = params[:book][:picture]
        File.open(Rails.root.join('public', 'uploads', "#{@book.id}.jpg"), 'wb') do |file|
          file.write(uploaded_io.read)
        end
      end

      redirect_to @book
    else
      render 'new'
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    if File.exist?(Rails.root.join('public', 'uploads', "#{@book.id}.jpg"))
      File.delete(Rails.root.join('public', 'uploads', "#{@book.id}.jpg"))
    end
    redirect_to books_path
  end

  private
  def book_params
    params.require(:book).permit(:title, :description,:isbn)
  end

end
