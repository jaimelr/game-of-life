require 'spec_helper'
require 'life'

RSpec.describe Cell do
  subject { described_class.new(value) }

  describe '#initialize' do
    context 'when cell is created' do
      let(:value) { 1 }
      it 'has an id' do
        expect(subject.id).to eq 1
      end
    end
  end

  describe '#is_alive?' do
    context 'when cell is alive' do
      let(:value) { 1 }
      it 'returns true' do
        expect(subject.is_alive?).to eq true
      end
    end
    context 'when cell is not alive' do
      let(:value) { 0 }
      it 'returns false' do
        expect(subject.is_alive?).to eq false
      end
    end
  end

  describe '#dies' do
    context 'when cell dies' do
      let(:value) { 1 }
      it 'cell\'s id is 0' do
        subject.dies
        expect(subject.id).to eq 0
      end
    end
  end

  describe '#resuscitates' do
    context 'when cell resuscitates' do
      let(:value) { 1 }
      it 'cell\'s id is \'X\'' do
        subject.resuscitates
        expect(subject.id).to eq 1
      end
    end
  end
end

RSpec.describe Board do
  subject { described_class.new(value, value2) }

  describe '#initialize' do
    context 'when board is created' do
      let(:value) { 20 }
      let(:value2) { 10 }
      it 'has a width' do
        expect(subject.width).to eq 20
      end
      it 'has a height' do
        expect(subject.height).to eq 10
      end
      it 'has a two-dimensional array' do
        expect(subject.array[0].is_a?(Array)).to eq true
      end
    end
  end
  describe '#reset' do
    context 'when board is reset' do
      let(:value) { 10 }
      let(:value2) { 10 }
      it 'all cell ids are 0' do
        subject.reset
        subject.array.each do |row|
          row.each { |cell| expect(cell.id).to eq 0 }
        end
      end
    end
  end
end

RSpec.describe Game do
  subject { described_class.new(value) }

  describe '#initialize' do
    context 'when game is instantiated' do
      let(:value) { Board.new(10, 10) }
      it 'has a board to play with' do
        expect(subject.board.class).to eq Board.new(10, 10).class
      end
    end
  end
end
