class MoviesController < ApplicationController

  def my_logger
    @@my_logger = Logger.new("#{Rails.root}/log/my.log")
  end
  
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def initialiseRatings
    @all_ratings = Movie.ratings
    @ratings = params[:ratings]
    if (!@ratings.nil?)
      my_logger.info "ratings are:"
      @ratings.each_key do |key|
        my_logger.info key   
      end
    end   
  end
  
  def index
    initialiseRatings
    if !params[:sorted].nil?
      @movies = Movie.all(:order => params[:sorted])
    end
    if params[:sorted] == 'title'
      @titleHighlight="hilite"
      @releaseHighlight=""
    elsif params[:sorted] == 'release_date'
      @releaseHighlight="hilite"
      @titleHighlight=""
    else
      @movies = Movie.all()
    end

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
