class Movie < ActiveRecord::Base
  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end

class Movie::InvalidKeyError < StandardError ; end
  
  def self.create_from_tmdb(id)
    begin 
      Tmdb::Api.key("f4702b08c0ac6ea5b51425788bb26562")
      movie = Tmdb::Movie.detail(id)
      if (movie)
        Movie.create!({:title => (movie['title']), :rating => (get_rating(Tmdb::Movie.releases(movie['id']))), :description => (movie['overview']), :release_date => (movie['release_date'])})
      end
    rescue Tmdb::InvalidApiKeyError
      raise Movie::InvalidKeyError, 'Invalid API key'
    end
  end
  
  def Movie.get_rating(releases)
    countries = releases['countries']
    rating = "PG"
    if (countries)
      countries.each do |country|
        if (country['iso_3166_1'] == 'US' and country['certification'] != "")
          rating = country['certification']
        end
      end
    end
    return rating
  end
  
  def self.find_in_tmdb(string)
    begin
      @string = string
      Tmdb::Api.key("f4702b08c0ac6ea5b51425788bb26562")
      tbdb_movies = Tmdb::Movie.find(string)
      @returnArray = []
      tbdb_movies.each do |movie|
        @returnArray.push(Hash[:id => movie.id, :title => movie.title, :rating => get_rating(Tmdb::Movie.releases(movie.id)), :release_date => movie.release_date])
      end
      return @returnArray
    rescue Tmdb::InvalidApiKeyError
      raise Movie::InvalidKeyError, 'Invalid API key'
    end
  end
end
