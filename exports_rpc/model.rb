require 'sqlite3'
require 'active_record'
require 'core/distributed_eventing'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'db'
)
if ActiveRecord::Base.connection.tables.empty?
  ActiveRecord::Migration.class_eval do
    create_table :exports do |t|
      t.integer :employer_id
      t.timestamps
    end

    create_table :exported_files do |t|
      t.integer :export_id
      t.string :status
      t.string :url
      t.timestamps
    end
  end
end

module ChangePublisher
  def self.included(base)
    base.class_exec do
      after_save :publish_change_event
    end
  end

  private
  def publish_change_event
    payload = self.attributes.dup
    payload[:__class__] = self.class
    publish(JSON.dump(payload))
    self
  end
end

class Export < ActiveRecord::Base
  include Core::DistributedEventing
  include ChangePublisher
  has_many :exported_files
  attr_reader :latest_file
  after_initialize :init
  default_scope {includes(:exported_files)}

  private
  def init
    @latest_file = exported_files
      .select(&completed?)
      .sort(&desc_date).first
  end

  def completed?
    ->(exported_file) {exported_file.complete?}
  end

  def desc_date
    ->(i,j) {j.created_at <=> i.created_at}
  end
end

class ExportedFile < ActiveRecord::Base
  include Core::DistributedEventing
  include ChangePublisher
  belongs_to :export
  after_initialize :init
  after_find :update_status

  def default_scope
    {order: {created_at: :DESC}}
  end

  def processing?
    status == 'PROCESSING'
  end

  def complete?
    status == 'COMPLETE'
  end

  private
  def init
    self.status ||= 'PROCESSING'
  end

  def update_status
    if processing? && older_than_a_minute?
      update_attributes!(status: 'COMPLETE', url: 'http://localhost:3000/')
    end
  end

  def older_than_a_minute?
    created_at < 1.minute.ago
  end
end
