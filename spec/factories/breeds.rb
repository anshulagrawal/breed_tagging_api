FactoryBot.define do
  factory :breed do
    name {Faker::Name.name}
    tags {FactoryBot.build_list(:tag, rand(3..10))}
  end
  factory :breed_hash, class: Hash do
    name {Faker::Name.name}
    tags {FactoryBot.build_list(:tag_hash, rand(1..15))}

    initialize_with {attributes}
  end
  factory :breed_request_hash, class: Hash do
    breed {FactoryBot.build(:breed_hash)}
    
    initialize_with {attributes}
  end
end
