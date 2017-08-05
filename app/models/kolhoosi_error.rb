class KolhoosiError

  attr_accessor :message, :errors

  def initialize (message = 'An error occurred', errors = [])
    @message = message
    @errors = errors
  end


end