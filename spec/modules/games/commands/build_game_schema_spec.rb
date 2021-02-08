require 'rails_helper'

describe Games::Commands::BuildGameSchema do
  it 'builds default games schema' do
    schema = {
      frames: [[]] * 10,
      current_frame: 1,
      active: true,
      bonus: []
    }
    expect(subject.call).to eq schema
  end
end
