class Movie < ActiveRecord::Base

  def self.return_ratings
    return ['G', 'PG', 'PG-13', 'R'] 
  end

end
