class MoviesController < ApplicationController
  
  #include MoviesHelper

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    #Load Session and redirect if required
    redirect = 0
    if session.has_key?(:ratings) && !params[:ratings]
      params[:ratings] = session[:ratings]
      redirect = 1
    end
    if !params[:sort_param]
      params[:sort_param] = session[:sort_param]
      redirect = 1
    end
    
    #Redirect (caused issues)
    #if redirect
    #  redirect = 0
    #  flash.keep
    #  redirect_to movies_path(:sort_param => session[:sort_param], :ratings => session[:ratings])
    #end
    
    
    # Checkboxes
    query_ratings = []
    @all_ratings = Movie.return_ratings
    if params.has_key?(:ratings)
      @all_ratings.each do |rating|
        if  params[:ratings][:"#{rating}"]
          query_ratings.append(params[:ratings][:"#{rating}"])  
        end
      end
    end
    
    # Query
    @movies = []
    query_ratings.each do |query|
      found_movie = Movie.all.where(rating: "#{query}")
      found_movie.each do |movie|
        @movies.append(movie)
      end
    end
    
    # Sorting parameters
    if params[:sort_param] == "title"
      @movies = @movies.sort_by { |movie| movie.title}
    elsif params[:sort_param] == "date"
      @movies = @movies.sort_by { |movie| movie.release_date}
    end
    
    #Save session
    session[:ratings] = params[:ratings]
    session[:sort_param] = params[:sort_param]
    
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
