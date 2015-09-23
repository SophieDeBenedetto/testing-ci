class Results < ActiveRecord::Base

  serialize :messages

  # should have pr identifier (look at payload, what unique identifier do thay use)
  # should have requesters name

end