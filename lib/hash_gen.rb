### NOTE: Ideally, this should be replaced by something like https://github.com/jsonapi-rb/jsonapi-rb
###       Avoiding that in interest of time and ease of testing, etc for now
module HashGen
  def self.breeds(_breeds)
    res = {
      breeds: _breeds.map {|_breed| breed(_breed)} 
    }
  end
  def self.breed(_breed)
    {
      id: _breed.id,
      name: _breed.name,
    }.merge(tags(_breed.tags))
  end
  def self.tags(_tags)
    {
      tags: _tags.map{|_tag| tag(_tag)}
    }
  end
  def self.tag(_tag)
    {
      id: _tag.id,
      name: _tag.name
    }
  end
end
