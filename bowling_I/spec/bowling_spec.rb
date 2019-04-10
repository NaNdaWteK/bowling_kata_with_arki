describe 'Bowling' do
  it 'a game has frames objects in' do
    first_game = Game.new

    result= first_game.frames

    expect(result[0]).to be_instance_of Frame

  end

  it 'frame sum its pins down puntuation based in its two roll objects' do
    first_frame = Frame.new

    first_frame.set_rolls(not_full_pins_down_puntuation)

    expect(first_frame.score).to eq 7
    expect(first_frame.rolls[0]).to be_instance_of (Roll)
    expect(first_frame.rolls.size).to eq 2
  end



  it 'check if frame is a spare' do
    first_frame = frame_spared

    expect(first_frame.spare?).to be true
  end

  def not_full_pins_down_puntuation
    first_roll = Roll.new
    first_roll.set_pins_down 4
    second_roll = Roll.new
    second_roll.set_pins_down 3

    [first_roll, second_roll]
  end

  def full_pins_down_puntuation
    first_roll = Roll.new
    first_roll.set_pins_down 4
    second_roll = Roll.new
    second_roll.set_pins_down 6
    [first_roll, second_roll]
  end

  def frame_spared
    first_frame = Frame.new
    first_frame.set_rolls(full_pins_down_puntuation)
    first_frame
  end

end

class Frame

  FULL_PINS_DOWN_IN_TWO_ROLLS = 10

  def initialize
    @rolls = nil
  end

  def set_rolls(rolls)
    @rolls = rolls
  end

  def rolls
    @rolls
  end

  def score
    rolls_pins_down
  end

  def spare?
    rolls_pins_down == FULL_PINS_DOWN_IN_TWO_ROLLS
  end

  private

  def first_roll
    @rolls[0]
  end
  def second_roll
    @rolls[1]
  end

  def rolls_pins_down
    first_roll.pins_down + second_roll.pins_down
  end
end


class Game

  FRAMES_IN_GAME = 10

  def initialize
    @frames = []
    init_frames
  end

  def frames
    @frames
  end

  private

  def init_frames
    FRAMES_IN_GAME.times do
        @frames.push Frame.new
    end
  end

end

class Roll
  def initialize
    @pins_down
  end

  def set_pins_down(num_pins)
    @pins_down = num_pins
  end

  def pins_down
    @pins_down
  end

end
