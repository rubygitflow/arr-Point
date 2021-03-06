class User < ApplicationRecord
  include Auxiliary

  attr_accessor :role_rules_accepted

  has_one :driver, dependent: :destroy
  has_many :cars, -> { order(created_at: :desc) }, dependent: :destroy
  has_many :payments

  scope :available_cars, -> { where(role: 'Driver', lock: false).joins(:cars)
    .where( cars: { workhorse: true} ) }
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :authy_authenticatable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Normalizes the attribute itself before validation
  phony_normalize :phone, default_country_code: 'RU'

  EMAIL_VALIDATION = /.+@.+\..+/i

  validates :email, :name, :phone, :role, presence: true

  validates :email, uniqueness: true, case_sensitive: false, 
    format: { with: EMAIL_VALIDATION }

  validates_acceptance_of :role_rules_accepted

  def country_code
    @country_code ||= PhonyRails.country_code_from_number(phone)
  end  

  def phone_number
    @phone_number ||= Phony.formatted(Phony.normalize(phone))
  end  

  def random_email
    @random_email ||= random_string+'@email.com'
  end

  def authy_hook_turn_off
    update!(authy_hook_enabled: false)
    update!(authy_enabled: false)  
  end

  def authy_hook_turn_on
    update!(authy_hook_enabled: true, last_sign_in_with_authy: nil)
  end

  def driver?
    role == 'Driver'
  end

  def passenger?
    role == 'Passenger'
  end

  def owner?(resource)
    resource.user_id == id
  end

  def toggle!
    update!(lock: !lock)  
  end

  def does_hook_before_full_phone_authorization?
   authy_hook_enabled && !authy_id && !last_sign_in_with_authy 
  end

  def is_still_need_phone_authorization?
    authy_hook_enabled && authy_id && !last_sign_in_with_authy
  end

  def is_passenger_with_permissions?
   !authy_hook_enabled && passenger? && !lock
  end

  def finished_phone_authorization?
    authy_hook_enabled && last_sign_in_with_authy
  end
end
