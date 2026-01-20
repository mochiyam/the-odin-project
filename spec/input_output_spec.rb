require './lib/input_output'

describe NumberGame do
  subject(:game) { described_class.new }
  describe '#initialize' do
    context 'when user initialize' do
      it 'is solution greater than or equal 0' do
        solution = game.solution
        expect(solution).to be >= 0
      end

      it 'is solution less than or equal 9' do
        solution = game.solution
        expect(solution).to be <= 9
      end
    end
  end

  describe '#game_over?' do
    context 'when user guess is correct' do
      # To test this method, we need to set specific values for @solution and
      # @guess, so we will create a new instance of NumberGame. When creating
      # another instance of NumberGame, we'll use a meaningful name to
      # differentiate between instances.

      # A helpful tip is to combine the purpose of the test and the object.
      # E.g., game_end or complete_game.

      subject(:game_end) { described_class.new(5, '5') }

      it 'is game over' do
        expect(game_end).to be_game_over
      end
    end

    context 'when user guess is incorrect' do
      subject(:game_not_end) { described_class.new(6, '5') }

      it 'is not game over' do
        expect(game_not_end).to_not be_game_over
      end
    end
  end

  describe "#verify_input" do
    subject(:game_verify) { described_class.new }

    it 'when given valid input' do
      verify = game_verify.verify_input('3')
      expect(verify).to eq('3')
    end
  end

  describe '#player_turn' do
   # In order to test the behavior of #player_turn, we need to use a method
    # stub for #player_input to return a valid_input ('3'). To stub a method,
    # we 'allow' the test subject (game_loop) to receive the :method_name
    # and to return a specific value.
    # https://rspec.info/features/3-12/rspec-mocks/basics/allowing-messages/
    # http://testing-for-beginners.rubymonstas.org/test_doubles.html
    # https://edpackard.medium.com/the-no-problemo-basic-guide-to-doubles-and-stubs-in-rspec-1af3e13b158

    subject(:game_loop) { described_class.new }

    context 'when user input is valid' do
      # To test the behavior, we want to test that the loop stops before the
      # puts 'Input error!' line. In order to test that this method is not
      # called, we use a message expectation.
      # https://rspec.info/features/3-12/rspec-mocks/
      
      it 'stops loop and does not display error message' do
        valid_input = '3'
        allow(game_loop).to receive(:player_input).and_return(valid_input)
        expect(game_loop).not_to receive(:puts).with('Input error!')
        game_loop.player_turn
      end 
    end
  end
end