class Task < ApplicationRecord

  enum status: { initialized: 0, started: 1, paused: 2, stopped: 3 }

  belongs_to :project
end
