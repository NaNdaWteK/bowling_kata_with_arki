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
    expect(score).to eq 68
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
  actual_frame = frames[index]

  if frame_is_a_bonus?(frames,index)

    if frame_is_a_spare?(frames[index])
      result += score_of_spare(frames, index)
    end

    if frame_is_a_strike?(frames,index)
      result += score_of_strike(frames, index)
    end

  else
      result += frame_points(actual_frame)
  end

  result
end

def frame_points(frame)
  score = 0
  if frame[0].match?(/[0-9]/)
    score += frame[0].to_i
  end
  if frame[1].match?(/[0-9]/)
    score += frame[1].to_i
  end
  score
end

def bonus_next_roll(frames, index)
  bonus_score = 0
  next_roll = frames[index + 1][0]
  if next_roll.match?(/[0-9]/)
    bonus_score = next_roll.to_i
  end
  return bonus_score
end

def score_of_spare(frames, index)
  score = 10
  score += bonus_next_roll(frames ,index)
  score
end

def score_of_strike(frames, index)
  score = 20
  score += bonus_next_two_rolls(frames, index)
  score
end

def bonus_of_strike(frames, index)
  score = 0
  score += 10
  if frames[index + 1][0].match?(/[0-9]/)
    score += frame[1].to_i
  end
  score
end

def bonus_next_two_rolls(frames, index)
  bonus_score = 0
  next_frame_index = index + 1
  if frame_is_a_spare?(frames[next_frame_index])
    bonus_score += 10
  end
  if frame_is_a_strike?(frames, next_frame_index)
    bonus_score += 10
  end
  unless frame_is_a_bonus?(frames, next_frame_index)
    next_frame = frames[next_frame_index]
    next_frame.each_char do |roll|
      if roll.match?(/[0-9]/)
        bonus_score += roll.to_i
      end
    end
  end
  return bonus_score
end

def frame_is_a_strike?(frames,index)
  frames[index].include? 'X'
end

def frame_is_a_spare?(frame)
  frame.include? '/'
end

def frame_is_a_bonus?(frames,index)
  frame_is_a_strike?(frames,index) || frame_is_a_spare?(frames[index])
end
