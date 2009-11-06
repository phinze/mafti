require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))
require 'mafti'

describe Mafti do
  describe '.open' do
    describe 'for an empty file' do
      it 'outputs a Mafti instance with no data' do
        filename = 'empty_file.txt'
        io = StringIO.new('')
        File.should_receive(:open).with(filename).and_return(io)
        ret = Mafti.open(filename)
        ret.should be_an_instance_of(Mafti)
        ret.data.should ==([])
      end
    end

    describe 'for a valid file' do
      it 'returns an instance with data parsed and available' do
        filename = 'valid_file.txt'
        io = StringIO.new(<<-END.gsub(/^ */,''))
          ----------------------------------------
          | Foo        |  Bar       | Baz        | 
          ----------------------------------------
          | A1         |  B1        | C1         | 
          ----------------------------------------
          | A2         |  B2        | C2         | 
          ----------------------------------------
        END
        File.should_receive(:open).and_return(io)
        m = Mafti.open(@valid_file)
        m.data.should ==([
          ['A1' ,'B1' ,'C1' ],
          ['A2' ,'B2' ,'C2' ]
        ])
        m.headers.should ==(['Foo','Bar','Baz'])
      end
    end
  end

  describe '#as_hashes' do
    it 'returns data as an array of hashes' do
      m = Mafti.new
      m.headers = ['a','b','c']
      m.data = [ ['1','2','3'], ['4','5','6'], ]
      hashes = m.as_hashes
      hashes.should ==([
        {'a' => '1', 'b' => '2', 'c' => '3'},
        {'a' => '4', 'b' => '5', 'c' => '6'},
      ])
    end

    # whoops, regression test for something stupid i did
    it 'does not delete data' do
      m = Mafti.new
      m.headers = ['a','b','c']
      m.data = [ ['1','2','3'], ['4','5','6'] ]
      data_before   = m.data
      first_hashes  = m.as_hashes
      second_hashes = m.as_hashes
      data_after    = m.data

      second_hashes.should        ==(first_hashes)
      second_hashes.should_not equal(first_hashes)
      data_before.should ==(data_after)
    end
  end
end
