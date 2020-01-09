require 'active_storage/attachment'

class ActiveStorage::Attachment
  after_commit do
    MusicAnalyzeJob.perform_later
  end
end
