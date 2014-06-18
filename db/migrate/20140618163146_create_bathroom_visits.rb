class CreateBathroomVisits < ActiveRecord::Migration
  def change
    create_table :bathroom_visits do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.boolean :active

      t.timestamps
    end
  end
end
