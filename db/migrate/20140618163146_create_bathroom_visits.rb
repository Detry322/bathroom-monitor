class CreateBathroomVisits < ActiveRecord::Migration
  def change
    create_table :bathroom_visits do |t|
      t.date :start_time
      t.date :end_time
      t.boolean :active

      t.timestamps
    end
  end
end
