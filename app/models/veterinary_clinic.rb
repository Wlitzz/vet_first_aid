# =============================================================================
# VeterinaryClinic Model
# SWE30003 – Group 17 | Clinic Locator Lead
#
# Responsibilities (from CRC Card, A2 §3.3.12):
#   - Knows clinic identity (name, address, geolocation, hours, contact,
#     emergency status)
#   - Sorts a candidate list of clinics by distance from a given location
#   - Filters by availability (Open Now, 24/7 Emergency)
#   - Updates its record under administrator control
#
# Inherits from ApplicationRecord (ActiveRecord::Base) so that all attributes
# are persisted via the CreateVeterinaryClinics migration.
#
# DB column → Ruby interface mapping
#   is_emergency     → #emergency_24_7   (Boolean alias used by views/controller)
#   is_open_now      → #open_now?        (pre-computed flag; see note below)
#   open_hours       → #opening_hours    (String in DB, parsed to Hash on read)
#   accepted_species → #species_accepted (comma-separated String ↔ Array<String>)
#
# Note on open_now / is_open_now:
#   The migration stores a pre-computed boolean for fast DB filtering.
#   open_now? reads this column directly.  If you want real-time calculation
#   instead, replace the open_now? body with the time-parsing logic that was
#   in the original plain-Ruby model (kept below as open_now_realtime? for
#   reference).
# =============================================================================
class VeterinaryClinic < ApplicationRecord

  # ---------------------------------------------------------------------------
  # Constants
  # ---------------------------------------------------------------------------
  EARTH_RADIUS_KM      = 6371.0
  STALE_THRESHOLD_DAYS = 90
  SPECIES_LIST         = %w[Dog Cat Rabbit Hamster].freeze
  AVAILABILITY_FILTERS = %w[open_now emergency_24_7].freeze
  DAY_ABBREVIATIONS    = %w[Sun Mon Tue Wed Thu Fri Sat].freeze

  # ---------------------------------------------------------------------------
  # Serialisation
  # accepted_species is stored as a comma-separated string in the DB column

# accepted_species: stored as comma-separated string in DB, exposed as Array.
# The getter always returns an Array regardless of how Rails stores the attribute.
def accepted_species
  raw = super.to_s
  raw.gsub(/[\[\]"']/, '').split(",").map(&:strip).reject(&:empty?)
end

before_save do
  write_attribute(:accepted_species, accepted_species.join(","))
end

  # ---------------------------------------------------------------------------
  # ActiveRecord validations  (mirrors the original plain-Ruby validate! guards)
  # ---------------------------------------------------------------------------
  validates :name,      presence: true
  validates :address,   presence: true
  validates :phone,     presence: true
  validates :latitude,  presence: true,
                        numericality: { greater_than_or_equal_to: -90,
                                        less_than_or_equal_to:    90 }
  validates :longitude, presence: true,
                        numericality: { greater_than_or_equal_to: -180,
                                        less_than_or_equal_to:    180 }
  validate  :species_must_be_known

  # ---------------------------------------------------------------------------
  # Scopes
  # ---------------------------------------------------------------------------
  scope :active,    -> { where(active: true) }
  scope :emergency, -> { where(is_emergency: true) }
  scope :open_now,  -> { where(is_open_now: true) }

  # Used by ClinicsController: VeterinaryClinic.all_active
  def self.all_active
    active
  end

  # ---------------------------------------------------------------------------
  # Attribute aliases
  # Maps DB column names to the interface expected by views and the controller.
  # ---------------------------------------------------------------------------

  # Boolean: true when clinic operates 24/7 emergency service.
  def emergency_24_7
    is_emergency
  end

  # Array<String>: species this clinic accepts.
  # `accepted_species` is already deserialised by the serializer above;
  # this alias keeps the interface consistent with the original model.
  def species_accepted
    accepted_species
  end

  # ---------------------------------------------------------------------------
  # Opening-hours helpers
  # ---------------------------------------------------------------------------

  # Parses the `open_hours` DB string into a Hash keyed by three-letter day
  # abbreviation, e.g. { "Mon" => "08:00-18:00", "Tue" => "08:00-18:00", ... }
  #
  # Supported DB formats:
  #   "Mon:08:00-18:00,Tue:08:00-18:00"   (day:open-close per segment)
  #   "Mon-Fri:08:00-18:00,Sat:09:00-13:00" (range of days)
  #
  # Falls back to an empty hash if the string is blank or unparseable.
  def opening_hours
    @opening_hours_cache ||= parse_opening_hours(open_hours)
  end

  # Invalidate the memoised cache whenever open_hours changes.
  def open_hours=(val)
    @opening_hours_cache = nil
    super
  end

  # Human-readable string for today, e.g. "08:00-18:00" or "Closed".
  def todays_hours
    today_key = DAY_ABBREVIATIONS[Date.today.wday]
    opening_hours[today_key] || open_hours.presence || "Closed"
  end

  # ---------------------------------------------------------------------------
  # Availability checks
  # ---------------------------------------------------------------------------

  # Returns true when the clinic is open right now.
  # Reads the pre-computed is_open_now column for fast response.
  # Switch to open_now_realtime? if you prefer live calculation.
  def open_now?
    open_now_realtime?
  end

  # Real-time availability check based on parsed opening_hours.
  # Kept for reference; call this instead of open_now? if is_open_now is not
  # kept up-to-date by a background job.
  def open_now_realtime?
    return true if is_emergency

    today_key   = DAY_ABBREVIATIONS[Date.today.wday]
    hours_today = opening_hours[today_key]
    return false if hours_today.nil? || hours_today.downcase == "closed"

    open_str, close_str = hours_today.split("-").map(&:strip)
    now_mins   = time_to_minutes(Time.now.strftime("%H:%M"))
    open_mins  = time_to_minutes(open_str)
    close_mins = time_to_minutes(close_str)

    now_mins >= open_mins && now_mins < close_mins
  rescue StandardError
    false
  end

  # ---------------------------------------------------------------------------
  # Staleness check
  # ---------------------------------------------------------------------------

  # True when the record has not been verified within STALE_THRESHOLD_DAYS.
  def stale?
    return false if last_verified_at.nil?
    (Date.today - last_verified_at.to_date).to_i > STALE_THRESHOLD_DAYS
  end

  # ---------------------------------------------------------------------------
  # Admin update  (SRS Task 9 – Administrator responsibilities)
  # ---------------------------------------------------------------------------

  # Applies a hash of permitted attributes and marks the record as verified today.
  # Raises ActiveRecord::RecordInvalid if the new values fail validation.
  def update_clinic(attrs = {})
    permitted = %i[name address phone email website open_hours
                   is_emergency is_open_now accepted_species active]
    assign_attributes(attrs.slice(*permitted))
    self.last_verified_at = Time.current
    save!
    self
  end

  # Soft-archive: hides the clinic from search results without destroying the row.
  def archive!
    update_column(:active, false)
    self
  end

  # ---------------------------------------------------------------------------
  # Detail summary  (used by ClinicsController#show and JSON API)
  # ---------------------------------------------------------------------------

  def detail_summary
    {
      id:               id,
      name:             name,
      address:          address,
      phone:            phone,
      email:            email,
      website:          website,
      emergency_24_7:   is_emergency,
      species_accepted: species_accepted,
      opening_hours:    opening_hours,
      last_verified_at: last_verified_at,
      stale:            stale?
    }
  end

  # ---------------------------------------------------------------------------
  # Distance calculation  (Haversine formula – SRS Task 4, subtask 2)
  # ---------------------------------------------------------------------------

  # Returns the great-circle distance in kilometres between this clinic and the
  # given coordinates.  Returns Float::INFINITY when either argument is nil so
  # that sort_by comparisons still work correctly.
  def distance_to(lat, lng)
    return Float::INFINITY unless lat && lng

    delta_lat = degrees_to_rad(latitude - lat.to_f)
    delta_lng = degrees_to_rad(longitude - lng.to_f)

    a = Math.sin(delta_lat / 2)**2 +
        Math.cos(degrees_to_rad(lat.to_f)) *
        Math.cos(degrees_to_rad(latitude)) *
        Math.sin(delta_lng / 2)**2

    EARTH_RADIUS_KM * 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))
  end

  # ---------------------------------------------------------------------------
  # Presentation
  # ---------------------------------------------------------------------------

  def to_s
    "#{name} (#{address})"
  end

  # ---------------------------------------------------------------------------
  # Class-level search helpers  (SRS Task 4 sequence diagram)
  # ---------------------------------------------------------------------------

  class << self
    # Returns active clinics sorted by distance from (lat, lng).
    # Responsibility: "Sorts a candidate list of clinics by distance from a
    # given location" (A2 §3.3.12).
    def sorted_by_distance(clinics, lat, lng)
      Array(clinics)
        .select(&:active)
        .sort_by { |c| c.distance_to(lat, lng) }
    end

    # Applies availability + species filters.
    # Responsibility: "Filters by availability" (A2 §3.3.12).
    #
    # Supported filter keys (all optional):
    #   :open_now       → only clinics where open_now? is true
    #   :emergency_24_7 → only clinics where emergency_24_7 is true
    #   :species        → only clinics whose species_accepted includes the value
    def apply_filters(clinics, filters = {})
      result = Array(clinics).select(&:active)

      result = result.select(&:open_now?)       if filters[:open_now]
      result = result.select(&:emergency_24_7)  if filters[:emergency_24_7]

      if filters[:species].present?
        species_query = filters[:species].to_s.downcase
        result = result.select do |c|
          c.species_accepted.map(&:downcase).include?(species_query)
        end
      end

      result
    end

    # Expands search radius automatically (30 → 60 → 100 km) until results are
    # found.  Responsibility matches SRS Task 4, Variant 1a.
    def search_with_radius_expansion(clinics, lat, lng, filters = {})
      [30, 60, 100].each do |radius_km|
        nearby   = sorted_by_distance(clinics, lat, lng)
                     .select { |c| c.distance_to(lat, lng) <= radius_km }
        filtered = apply_filters(nearby, filters)
        return { clinics: filtered, radius_used: radius_km } if filtered.any?
      end

      { clinics: [], radius_used: 100 }
    end
  end

  # ---------------------------------------------------------------------------
  private
  # ---------------------------------------------------------------------------

  # Custom validation: every entry in accepted_species must be in SPECIES_LIST.
  def species_must_be_known
    raw = accepted_species.to_s
    species = raw.gsub(/[\[\]"']/, '').split(",").map(&:strip).reject(&:empty?)
    invalid = species - SPECIES_LIST
    errors.add(:accepted_species, "contains unknown species: #{invalid.join(', ')}") if invalid.any?
  end

  # Converts decimal degrees to radians.
  def degrees_to_rad(deg)
    deg * Math::PI / 180.0
  end

  # Converts "HH:MM" to total minutes since midnight.
  def time_to_minutes(time_str)
    h, m = time_str.split(":").map(&:to_i)
    h * 60 + m
  end

  # Parses the `open_hours` string stored in the DB into a day-keyed Hash.
  #
  # Handles two formats:
  #   1. Single-day segments:  "Mon:08:00-18:00,Tue:08:00-18:00"
  #   2. Day-range segments:   "Mon-Fri:08:00-18:00,Sat:09:00-13:00"
  def parse_opening_hours(raw)
    return {} if raw.blank?

    result = {}
    raw.split(",").each do |segment|
      segment = segment.strip
      # Split on first colon only to separate the day part from the time part.
      day_part, *time_parts = segment.split(":")
      time_str = time_parts.join(":").strip
      next if day_part.blank? || time_str.blank?

      day_part = day_part.strip

      if day_part.include?("-")
        # Range like "Mon-Fri"
        start_day, end_day = day_part.split("-").map(&:strip)
        start_idx = DAY_ABBREVIATIONS.index(start_day)
        end_idx   = DAY_ABBREVIATIONS.index(end_day)
        next unless start_idx && end_idx

        # Handle wrap-around (e.g. "Fri-Sun")
        indices = if start_idx <= end_idx
                    (start_idx..end_idx).to_a
                  else
                    (start_idx..6).to_a + (0..end_idx).to_a
                  end
        indices.each { |i| result[DAY_ABBREVIATIONS[i]] = time_str }
      else
        result[day_part] = time_str
      end
    end

    result
  rescue StandardError
    {}
  end
end