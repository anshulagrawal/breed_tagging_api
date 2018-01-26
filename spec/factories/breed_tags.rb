FactoryBot.define do
  factory :breed_tag do
    breed {FactoryBot.build(:breed)}
    tag {FactoryBot.build(:tag)}
  end
end
