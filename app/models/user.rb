class User < ApplicationRecord
  has_secure_password
  has_many :commune_users, :dependent => :destroy
  has_many :communes,through: :commune_users
  has_many :commune_admins
  has_many :admin_communes, through: :commune_admins, :source => :commune
  has_many :task_completions
  has_many :invitations
  has_many :purchases

  validates :username, presence: true, uniqueness: true, length: {in: 2..30}
  validates :name, presence: true, length: {in: 2..30 }
  validates :password, confirmation: true, length: { in: 8..20 }, :if => :password
  validates :password_confirmation, presence: true, :if => :password

  def self.from_token_request request
    username = request.params['auth'] && request.params['auth']['username']
    self.find_by username: username
  end

  def to_json
    super(:except => [:password_digest])
  end


  def not_found
    @error = KolhoosiError.new('Username or password wrong.')
    render 'error', status: 401
  end

end
