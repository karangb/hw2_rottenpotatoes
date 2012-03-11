module MoviesHelper
  # Checks if a number is odd:
  def oddness(count)
    count.odd? ?  "odd" :  "even"
  end
  
  def includeRating(rating)
    if (session.has_key? :ratings)
      params[:ratings].include? rating
    end
  end
  
  def sortHighlight(header)
    if header == params[:sorted]
      'hilite'
    end
  end
end
