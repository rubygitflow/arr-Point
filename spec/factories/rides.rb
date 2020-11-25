FactoryBot.define do
  factory :ride do
    car
    departure { 'City' }
    arrival { 'Village' }
    cost { '2000' }
    # when { '20:00' }

    trait :execute do
      status { 'Execution' }
    end  

    trait :complete do
      status { 'Completed' }
    end  

    trait :reject do
      status { 'Rejected' }
    end  

    trait :abort do
      status { 'Aborted' }
    end  
  end
end
