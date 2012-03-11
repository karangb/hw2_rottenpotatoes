class MoviesController < ApplicationController

  def my_logger
    @@my_logger = Logger.new("#{Rails.root}/log/my.log")
  end
  
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.ratings
    if (params[:ratings].is_a? Hash)
      params[:ratings] = params[:ratings].keys
    end
    redirectNeeded = false
    if params.has_key?(:ratings)
      session[:ratings] = params[:ratings]
    elsif params[:commit] == "Refresh" || !(session.has_key? :ratings) 
        params[:ratings] = Movie.ratings
    else
      params[:ratings] = session[:ratings]
      redirectNeeded = true
    end
    
    if (params.has_key?(:sorted))
      session[:sorted] = params[:sorted]
    else
      params[:sorted] = session[:sorted]
      redirectNeeded = true
    end
    
    if (redirectNeeded)
    redirect_to movies_path(:sorted => params[:sorted], :ratings => params[:ratings])
    end

    @movies = Movie.all(:order => params[:sorted], :conditions => ["rating IN (?)", params[:ratings]])
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
