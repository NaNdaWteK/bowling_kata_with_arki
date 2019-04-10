describe 'Bowling tests' do
  let(:sequence) do
    "9- 9- 9- 9- 9- 9- 9- 9- 9- 9-"
  end

  it 'cuts the sequence in frames' do
      game1 = Game.new(sequence)

      frames = game1.frames

      expect(frames.count).to eq 10
  end

  it 'frame score is additions if are numbers' do
    game1 = Game.new(sequence)

    frames = game1.frames

    first_frame = Frame.new(frames[0])

    expect(first_frame.score).to eq 9
  end

  it 'calculate game score if frames are numbers' do
    game1 = Game.new(sequence)

    expect(game1.score).to eq 90
  end

  it 'calculate game score if frames are numbers' do
    game1 = Game.new(sequence)

    expect(game1.score).to eq 90
  end

  it 'frame score with a spare' do
    first_frame = Frame.new("1/")

    expect(first_frame.score).to eq 10
  end



end

class Frame
  def initialize(frame)
    @frame = frame
  end

  def score
    punctuation = 0
    if spare?()
      punctuation = 10
    end

    if normal_frame?()
      punctuation = 0
      @frame.each_char do |item|
        if item.match?(/[0-9]/)
          punctuation = punctuation + item.to_i
        end
      end
    end
    punctuation

  end

  def spare?
    @frame.include?("/")
  end

  def strike?
    @frame.downcase.include?("x")
  end

  def normal_frame?()
    !spare? && !strike?
  end




end





class Game
  def initialize(sequence)
    @frames = split_sequence_in_frames(sequence)
  end

  def frames
    @frames
  end

  def score
    result = 0
    @frames.each do |item|
      frame = Frame.new(item)
      result += frame.score
    end
    result
  end

  private

  def split_sequence_in_frames(sequence)
      sequence.split(" ")
  end

end
