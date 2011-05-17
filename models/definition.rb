#encoding = utf-8

class Definition
  include DataMapper::Resource

  property :id, Serial
  property :definition, Text, :lazy => false
  property :translation, Text, :lazy => false
  #eine Definition kann zu mehreren Schlagwörtern gehören
  has n, :keywords
  belongs_to :user, :required => false
  
  def self.fill file #file = open("txt").read
    file.each_line do |line| 
      line_array = line.split("\t")
    
      unless line_array[3].gsub('"',"").strip == ""
                                  
        if line_array[4] == "\n" #es gibt in dem Fall noch keine Übersetzung
          definition = Definition.first_or_create(:definition => line_array[3])
        else
          definition = Definition.first_or_create({:definition => line_array[3]}, {:translation => line_array[4]})
      
        end
        keyword = Keyword.first_or_create({:JDW => line_array[0]}, {:keyword => line_array[1], :reading => line_array[2]})
        
        definition.keywords << keyword
        keyword.save
      end
    end
  end


end

class Keyword
  include DataMapper::Resource

  property :id, Serial
  property :JDW, String, :unique => true
  property :keyword, String
  property :reading, String

  belongs_to :definition
  
  def self.user_keywords user_email
    user_keywords = Keyword.all(Keyword.definition.user.email => user_email) 
    all = user_keywords.map do |key| 
            key.JDW + "\t" + key.keyword + "\t" +
            key.reading + "\t" + key.definition.definition + 
            "\t" + key.definition.translation.to_s.delete("\n")
          end
    
    all.join("\n")
  end

end
DataMapper.finalize

