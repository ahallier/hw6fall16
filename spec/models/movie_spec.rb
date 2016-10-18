
describe Movie do
  describe 'searching Tmdb by keyword' do
    context 'with valid key' do
      it 'should call Tmdb with title keywords' do
        expect( Tmdb::Movie).to receive(:find).with('Inception')
        Movie.find_in_tmdb('Inception')
      end
    end
    context 'with invalid key' do
      it 'should raise InvalidKeyError if key is missing or invalid' do
        allow(Tmdb::Movie).to receive(:find).and_raise(Tmdb::InvalidApiKeyError)
        expect {Movie.find_in_tmdb('Inception') }.to raise_error(Movie::InvalidKeyError)
      end
    end
    it 'should find movies and add them to a hash' do
      allow(Movie.get_rating('test')).to receive(:find_in_tmdb).with('Test').and_return("PG")
      allow(Tmdb::Movie).to receive(:find).and_return([
        instance_double(Tmdb::Movie, id: 123, title: 'Bob', release_date: 123)
      ])
      Movie.find_in_tmdb('Bob')     
    end
    it 'should call get_rating' do
      allow(Movie.get_rating('test')).to receive(:find_in_tmdb).with('Test').and_return("PG")
      Movie.find_in_tmdb('Bob')
    end
    it 'should create from tmdb' do
      allow(Tmdb::Movie).to receive(:detail).and_return(
        {'id' => 123, 'title' => 'Bob', 'release_date' => '123'}
      )
      expect(Movie).to receive(:create!)
      Movie.create_from_tmdb('977')
    end
  end
end
