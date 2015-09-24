class Result < ActiveRecord::Base

  serialize :messages

  validates_uniqueness_of :pr_id

  # should have pr identifier (look at payload, what unique identifier do thay use)
  # should have requesters name

end