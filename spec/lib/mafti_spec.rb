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
end
