class DriverPaymentService
  include Auxiliary
  # or look at 
  # https://ruby-doc.org/stdlib-2.5.1/libdoc/securerandom/rdoc/SecureRandom.html

  def initialize(ride, user)
    @ride = ride
    @user = user
    @payment = Payment.new
  end

  def call
    result = create_payment_content
  end

  private

  def create_payment_content
    @payment.rate = @ride.cost
    @payment.tariff = 0.05
    @payment.price = (@payment.tariff*@payment.rate).round(2)
    @payment.paid_up = false
    @payment.payment_confirmation = random_string(24)
    @payment.user = @user
    @payment.ride = @ride
    if @payment.save
      @payment.payment_confirmation
    end
  end
end
