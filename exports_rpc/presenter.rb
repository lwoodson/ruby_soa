require 'roar/representer/json'

module ExportRepresenter
  extend Forwardable
  include Roar::Representer::JSON

  def last_export_time
    return '' unless latest_file
    latest_file.created_at
      .in_time_zone("Central Time (US & Canada)").strftime("%I:%M%p %m/%d/%Y")
  end

  def last_file_link
    latest_file ? latest_file.url : ''
  end

  property :id
  property :employer_id
  property :last_export_time
  property :last_file_link
end
