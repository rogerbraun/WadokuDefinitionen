#encoding = utf-8

class Definition
  include DataMapper::Resource

  property :id, Serial
  property :definition, Text 
  property :translation, Text 
  property :updated_at, DateTime
  #eine Definition kann zu mehreren Schlagwörtern gehören
  has n, :comments
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

  before :save do
    self.updated_at = DateTime.now
  end
    
  after :save do 
    self.keywords.update(:updated_at => DateTime.now) 
  end
end

class Keyword
  include DataMapper::Resource

  property :id, Serial
  property :JDW, String, :unique => true
  property :keyword, String
  property :reading, String
  property :updated_at, String

  belongs_to :definition
  
  def self.user_keywords user_email
    user_keywords = Keyword.all(Keyword.definition.user.email => user_email).reject{|el| el.definition.translation.strip == ""} 
    all = user_keywords.map do |key| 
            key.JDW + "\t" + key.keyword + "\t" +
            key.reading + "\t" + key.definition.definition + 
            "\t" + key.definition.translation.to_s.delete("\n")
          end
    
    all.join("\n")
  end

end

class Comment
  include DataMapper::Resource

  property :id, Serial
  property :comment, Text
  property :author, String
  property :updated_at, DateTime
  belongs_to :definition, :required => false

  before :save do
    self.updated_at = DateTime.now
    self.definition.update(:updated_at => DateTime.now) if self.definition
  end
end 
DataMapper.finalize

