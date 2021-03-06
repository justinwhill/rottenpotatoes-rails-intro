class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    if params[:ratings] || session[:ratings]
      @chosen_ratings = params[:ratings] || session[:ratings]
    else
      @chosen_ratings = Hash[@all_ratings.collect { |rating| [rating, 1] }]
    end
    if params[:sort] != session[:sort] or params[:ratings] != session[:ratings]
      session[:sort] = params[:sort] || session[:sort]
      session[:ratings] = @chosen_ratings
      flash.keep
      redirect_to :sort => session[:sort], :ratings => @chosen_ratings
      return
    end
    @movies = Movie.where(rating: @chosen_ratings.keys).order(session[:sort])
    if session[:sort] == "title"
      @title_header = "hilite"
    elsif session[:sort] == "release_date"
      @release_header = "hilite"
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
