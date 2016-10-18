require 'spec_helper'
require 'rails_helper'

describe MoviesController do
  describe 'searching TMDb' do
    before :each do
      @fake_results = [{},{}]
    end
    it 'should call the model method that performs TMDb search' do
      expect(Movie).to receive(:find_in_tmdb).with('Ted').
        and_return(@fake_results)
      post :search_tmdb, {:search_terms => 'Ted'}
    end
    describe 'after valid search' do
      it 'should select the Search Results template for rendering' do
        allow(Movie).to receive(:find_in_tmdb)
        post :search_tmdb, {:search_terms => 'Ted'}
        expect(response).to render_template('search_tmdb')
      end  
      it 'should make the TMDb search results available to that template' do
        allow(Movie).to receive(:find_in_tmdb).and_return (@fake_results)
        post :search_tmdb, {:search_terms => 'Ted'}
        expect(assigns(:matching_movies)).to eq(@fake_results)
      end
      it 'should set movies to empty array if none found' do
        allow(Movie).to receive(:find_in_tmdb).and_return ([])
        post :search_tmdb, {:search_terms => 'asdfdasfhasdfh'}
        expect(assigns(:matching_movies)).to eq([])
      end
    end
    describe 'after invalid search' do
      it 'should check for blank seach terms' do
        post :search_tmdb, {:search_terms => ''}
        expect(response).to redirect_to(movies_path)
      end
      it 'should check for nil seach terms' do
        post :search_tmdb, {:search_terms => nil}
        expect(response).to redirect_to(movies_path)
      end
    end
    it 'should call the model method that performs TMDb add' do
      expect(Movie).to receive(:create_from_tmdb)
      post :add_tmdb, {:tmdb_movies => {'977' => 1}}
      expect(response).to redirect_to(movies_path)
    end
    it 'should give message when no id is found' do
      post :add_tmdb, {:tmdb_movies => nil}
      expect(response).to redirect_to(movies_path)
    end
  end
end


