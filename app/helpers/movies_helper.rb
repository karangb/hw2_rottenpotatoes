module MoviesHelper
  # Checks if a number is odd:
  def oddness(count)
    count.odd? ?  "odd" :  "even"
  end
  
  def includeRating(rating)
    @ratings.include?(rating) unless @ratings.nil?
  end
end
