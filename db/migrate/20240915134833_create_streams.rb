class CreateStreams < ActiveRecord::Migration[7.1]
  def change
    create_table :streams do |t|
      t.string :stream_key
      t.datetime :starts_at
      t.datetime :ends_at

      t.timestamps
    end
  end
end
