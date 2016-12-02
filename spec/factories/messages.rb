FactoryGirl.define do
  factory :message do
    content 'this is example string'
    mode 'after_visit'
    time 2
    visit_count 1
    visits 4
  end
end
