require 'spec_helper'
require 'rails_helper'

describe MoviesController do
  describe 'searching TMDb' do
    before :each do
      @fake_results = Array.new(Hash.new, Hash.new)
    end
    it 'should call the model method that performs TMDb search' do
      expect(Movie).to receive(:find_in_tmdb).with('Ted').
        and_return(fake_results)
      post :search_tmdb, {:search_terms => 'Ted'}
    end
    describe 'after valid search' do
      it 'should select the Search Results template for rendering' do
        allow(Movie).to receive(:find_in_tmdb)
        post :search_tmdb, {:search_terms => 'Ted'}
        expect(response).to render_template('search_tmdb')
      end  
      it 'should make the TMDb search results available to that template' do
        allow(Movie).to receive(:find_in_tmdb).and_return (fake_results)
        post :search_tmdb, {:search_terms => 'Ted'}
        expect(assigns(:movies)).to eq(fake_results)
      end
    describe 'after invalid search' do
      it 'should check for blank seach terms' do
        post :search_tmdb, {:search_terms => ''}
        expect(response).to render_template('movies')
      end
      it 'should check for nil seach terms' do
        post :search_tmdb, {:search_terms => nil}
        expect(response).to render_template('movies')
      end
    end
  end
end