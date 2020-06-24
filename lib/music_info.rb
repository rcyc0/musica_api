# frozen_string_literal: true

require 'active_storage/attachment'

module ActiveStorage
  class Attachment
    after_commit do
      MusicAnalyzeJob.perform_later
    end
  end
end
