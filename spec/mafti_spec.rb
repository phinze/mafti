require 'spec_helper'
require 'mafti'

describe Mafti do
  it 'should exist' do
    (defined? Mafti).should be_true
  end

  describe '.import' do
    describe 'for nil input' do
      it 'outputs an empty array' do
        Mafti.import.should ==([])
      end
    end
   
    describe 'for an empty file' do
      it 'outputs an empty array' do
        Mafti.import(mock('File')).should ==([])
      end
    end

    describe 'for an iterable that returns strings' do
      describe 'of gibberish' do
        it 'outputs an empty array' do
          gibberer = mock('Gibberer')
          gibberer.stub!('each').and_yield('gibberish!', 'i say gibberish!')
          Mafti.import(gibberer).should_raise
        end
      end

      describe 'of a valid formatted text file' do
        before do
          @valid_lines = <<-END.gsub(/^ */,'').split("\n")
          ----------------------------------------
          | Foo        |  Bar       | Baz        | 
          ----------------------------------------
          | A1         |  B1        | C1         | 
          ----------------------------------------
          | A2         |  B2        | C2         | 
          ----------------------------------------
          END
          @valid_data = [
           ['Foo','Bar','Baz'],
           ['A1' ,'B1' ,'C1' ],
           ['A2' ,'B2' ,'C2' ],
          ]
          @valid_file = mock('File')
          @valid_file.stub!('each').and_yield(*@valid_lines)
        end

        it 'creates a 2D array of the data' do
          Mafti.import(@valid_data).should ==(@valid_data)
        end
      end
    end
  end
end
