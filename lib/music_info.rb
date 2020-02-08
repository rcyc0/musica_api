require 'active_storage/attachment'

class ActiveStorage
  class Attachment
    after_commit do
      MusicAnalyzeJob.perform_later
    end
  end
end
