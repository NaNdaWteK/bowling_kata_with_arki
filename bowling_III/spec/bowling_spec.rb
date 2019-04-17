describe 'Bowling' do
  it 'No pin downs scores 0 points' do
    sequence = '-- -- -- -- -- -- -- -- -- --'

    score=compute_score(sequence)

    expect(score).to eq 0
  end
  it 'Only one pin down scores 1 points' do
    sequence = '1- -- -- -- -- -- -- -- -- --'

    score=compute_score(sequence)

    expect(score).to eq 1
  end
  it 'One pin down in each roll of the first frame scores 2 points' do
    sequence = '11 -- -- -- -- -- -- -- -- --'
    score=compute_score(sequence)
    expect(score).to eq 2
  end

  it 'Two pins down in each roll of the first frame scores 4 points' do
    sequence = '22 -- -- -- -- -- -- -- -- --'
    score=compute_score(sequence)
    expect(score).to eq 4
  end

  it 'One pins down in each roll of entire game scores 20 points' do
    sequence = '11 11 11 11 11 11 11 11 11 11'
    score=compute_score(sequence)
    expect(score).to eq 20
  end

  it 'a spare in the first frame , add the bonus of pins down of the next roll' do
    sequence = '1/ 11 11 11 11 11 11 11 11 11'
    score=compute_score(sequence)
    expect(score).to eq 29
  end

  it 'a spare in the first frame , no add bonus points if not are pins down in the next roll' do
    sequence = '1/ -1 11 11 11 11 11 11 11 11'
    score=compute_score(sequence)
    expect(score).to eq 27
  end

  it 'a strike in the first frame , add the bonus of pins down of the next two rolls' do
    sequence = 'X 11 11 11 11 11 11 11 11 11'
    score=compute_score(sequence)
    expect(score).to eq 40
  end

  it 'a strike in the first frame , no add bonus points if not are pins down in the next two rolls' do
    sequence = 'X -- 11 11 11 11 11 11 11 11'
    score=compute_score(sequence)
    expect(score).to eq 36
  end

  it 'a strike in the first frame and a spare in the second frame add the bonus of each else' do
    sequence = 'X 2/ 11 11 11 11 11 11 11 11'
    score=compute_score(sequence)
    expect(score).to eq 57

    sequence = 'X 2/ -- 11 11 11 11 11 11 11'
    score=compute_score(sequence)
    expect(score).to eq 54
  end

  it 'a strike in the first and second frame , add the bonus of each else' do
    sequence = 'X X 11 11 11 11 11 11 11 11'
    score=compute_score(sequence)
    expect(score).to eq 69
  end
end



def compute_score(sequence)
  score = 0
  frames = sequence.split(' ')
  frames.each_with_index do |frame,index|
    is_bonus = false
    score += compute_frame_score(frames, index, is_bonus)
  end
  score
end



def compute_frame_score(frames, index, is_bonus)
  result = 0
  next_frame = get_next_frame(frames, index)
  next_roll = get_next_roll(next_frame)
  actual_frame = frames[index]
  spared = scores_spared_roll(actual_frame, next_roll, is_bonus)
  result += spared

  strike = scores_strike_roll(frames, index,is_bonus)
  result += strike

  if spared == 0 && strike == 0
    result += frame_points(actual_frame)
  end


  result
end

def frame_points(frame)
  score = 0
  frame.split('').each do |roll|
    score += normal_roll(roll)
  end
  score
end

def get_next_roll(next_frame)
  next_roll = next_frame[0]
  next_roll
end

def get_next_frame(frames, index)
  next_frame = frames[index + 1] || []
  next_frame
end



def normal_roll(pins_down)
  if pins_down.match?(/[0-9]/)
    return pins_down.to_i
  end
  return 0
end

def scores_spared_roll(frame, next_roll, is_bonus)
  score = 0
  if frame_is_a_spare?(frame)
    score = 10
    score += normal_roll(next_roll) unless is_bonus
  end
  score
end

def scores_strike_roll(frames, index,is_bonus)
  bonus_frame_is_a_strike = is_bonus && frame_is_a_strike?(frames,index)
  return bonus_of_strike(frames, index) if bonus_frame_is_a_strike
  score = 0
  if frame_is_a_strike?(frames,index)
    is_bonus = true
    score = 20
    next_frame_index = index + 1
    next_frame = get_next_frame(frames, index)
    score += compute_frame_score(frames, next_frame_index, is_bonus)
  end
  score
end

def bonus_of_strike(frames, index)
  score = 0
  score += 10
  score += normal_roll(frames[index + 1][0])
  score
end

def frame_is_a_strike?(frames,index)
    frames[index].include? 'X'
end

def frame_is_a_spare?(frame)
    frame.include? '/'
end
