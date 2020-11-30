FactoryBot.define do
  STATUSES = %w[Scheduled Execution Completed Aborted Rejected].freeze 

  sequence :status do |n|
    "#{STATUSES[n%5]}"
  end

  sequence :cost do |n|
    "#{(n % 5 + 1) * 100}"
  end

  factory :ride do


    car
    status
    cost 
    departure { 'City' }
    arrival { 'Village' }
    what_time { '20:00' }

    trait :schedule do
      status { 'Scheduled' }
    end  

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

  trait :route do
    status { 'Scheduled' }
    cost { '2000' }
  end
end
