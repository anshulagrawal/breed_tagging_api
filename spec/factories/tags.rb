FactoryBot.define do
  factory :tag_hash, class: Hash do
    name {Faker::Name.name}
    
    initialize_with {attributes}
  end
  factory :tag do
    name {Faker::Name.name}
  end
  factory :tags_request_hash, class: Hash do
    tags {FactoryBot.build_list(:tag_hash, rand(4..20))}
    
    initialize_with {attributes}
  end
end
