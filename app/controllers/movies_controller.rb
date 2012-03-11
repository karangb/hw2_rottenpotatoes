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
      session[:ratings] = @ratings.keys
      my_logger.info "ratings are:"
      @ratings.each_key do |key|
        my_logger.info key   
      end
    elsif params[:commit] == 'Refresh'
      session[:ratings] = @all_ratings
    end   
  end
  
  def index
    initialiseRatings
    @sortedBy = params[:sorted]
    if (params.has_key?(:ratings))
      ratingsSelected = params[:ratings].keys
    elsif (session.has_key?(:ratings))
      ratingsSelected = session[:ratings]
    else
      ratingsSelected = Movie.ratings
    end
    @movies = Movie.all(:order => @sortedBy, :conditions => ["rating IN (?)", ratingsSelected])
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
