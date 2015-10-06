class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
    	t.string :title
    	t.text :description
    end
  end
end
