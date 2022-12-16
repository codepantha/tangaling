# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string           not null
#  is_public              :boolean          default(TRUE), not null
#  last_name              :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  username               :string           not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_username              (username) UNIQUE
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         authentication_keys: [:login],
         reset_password_keys: [:login]

  attr_writer :login

  validates_uniqueness_of :email

  validates :email, uniqueness: true
  validates :username, uniqueness: true
  validates :first_name, presence: true
  validates :email, format: {
    with: URI::MailTo::EMAIL_REGEXP, 
    message: 'must be a valid email address' 
  }

  has_many :posts
  has_many :bonds

  has_many :followings,
    -> { where("bonds.state = ?", Bond::FOLLOWING) },
    through: :bonds,
    source: :friend

  has_many :follow_requests,
    -> { Bond.requesting },
    through: :bonds,
    source: :friend

  # defining inward_bonds which will help us find a user's followers
  has_many :inward_bonds, class_name: 'Bond', foreign_key: :friend_id

  has_many :followers,
    -> { Bond.following },
    through: :inward_bonds,
    source: :user

  before_save :ensure_proper_name_case

  def to_param
    username
  end

  def name
    if last_name
      "#{first_name} #{last_name}"
    else
      first_name
    end
  end

  def profile_picture_url
    @profile_picture_url ||= begin
      hash = Digest::MD5.hexdigest(email)
      "https://www.gravatar.com/avatar/#{hash}?d=wavatar"
    end
  end

  def login
    @login || username || email
  end

  # Overriding find_for_database_authentication so that a user
  # may sign in with a combination of username / email and password
  def self.find_authenticatable(login)
    where('username = :value OR email = :value', value: login).first
  end

  def self.find_for_database_authentication(conditions)
    conditions = conditions.dup
    login = conditions.delete(:login).downcase
    find_authenticatable(login)
  end

  # Override send_reset_password_instructions from devise
  def self.send_reset_password_instructions(conditions)
    recoverable = find_recoverable_or_init_with_errors(conditions)

    if recoverable.persisted?
      recoverable.send_reset_password_instructions
    end

    recoverable
  end

  def self.find_recoverable_or_init_with_errors(conditions)
    conditions = conditions.dup
    login = conditions.delete(:login).downcase
    recoverable = find_authenticatable(login)

    unless recoverable
      recoverable = new(login: login)
      recoverable.errors.add(:login, login.present? ? :not_found : :blank)
    end

    recoverable
  end

  private

  def ensure_proper_name_case
    self.first_name = first_name.capitalize
  end
end
