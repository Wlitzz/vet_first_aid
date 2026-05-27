class CreateVeterinaryClinics < ActiveRecord::Migration[7.1]
  def change
    create_table :veterinary_clinics do |t|
      # Identity
      t.string  :name,             null: false
      t.string  :address,          null: false
 
      # Geolocation — used by VeterinaryClinic#distance_to and sort_by_distance
      t.float   :latitude,         null: false
      t.float   :longitude,        null: false
 
      # Contact
      t.string  :phone,            null: false
 
      # Hours and availability filters
      t.string  :open_hours,       null: false
      t.boolean :is_open_now,      null: false, default: false
      t.boolean :is_emergency,     null: false, default: false
 
      # Species served — stored as comma-separated string e.g. "dog,cat,rabbit"
      t.string  :accepted_species, null: false, default: ""
 
      # Content freshness — records not verified within 90 days show a warning
      t.datetime :last_verified_at
 
      t.timestamps
    end
 
    # Index on lat/lng for the bounding-box pre-filter query in ClinicsController
    add_index :veterinary_clinics, [:latitude, :longitude]
    add_index :veterinary_clinics, :is_emergency
    add_index :veterinary_clinics, :is_open_now
  end
end
 


