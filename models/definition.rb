#encoding = utf-8

class Definition
  include DataMapper::Resource

  property :id, Serial
  property :definition, Text, :lazy => false
  property :translation, Text, :lazy => false
  #eine Definition kann zu mehreren Schlagwörtern gehören
  has n, :keywords
  
  def self.fill file #file = open("txt").read
    file.each_line do |line| 
    line_array = line.scan(/[^\t]+/) 
    puts line_array 
                              
    if line_array[4] == "\n" #es gibt in dem Fall noch keine Übersetzung
      definition = Definition.first_or_create(:definition => line_array[3])
      keyword = Keyword.create(:JDW => line_array[0], :keyword => line_array[1], :reading => line_array[2])
  
      definition.keywords << keyword
      definition.save
    
    else
      definition = Definition.first_or_create({:definition => line_array[3]}, {:translation => line_array[4]})
      keyword = Keyword.create(:JDW => line_array[0], :keyword => line_array[1], :reading => line_array[2])

      definition.keywords << keyword
      definition.save
  
    end
    end
  end


end

class Keyword
  include DataMapper::Resource

  property :id, Serial
  property :JDW, String
  property :keyword, String
  property :reading, String

  belongs_to :definition

end

DataMapper.finalize

