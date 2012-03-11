module MoviesHelper
  # Checks if a number is odd:
  def oddness(count)
    count.odd? ?  "odd" :  "even"
  end
  
  def includeRating(rating)
    if (session.has_key? :ratings)
      session[:ratings].include? rating
    end
  end
  
  def sortHighlight(header)
    if header == @sortedBy
      'hilite'
    end
  end
end
