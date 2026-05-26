# =============================================================================
# ClinicsController
# SWE30003 – Group 17 | Clinic Locator Lead
#
# Implements SRS Task 4: Locate Nearby Veterinary Clinic
# Sequence Diagram (A2 §7.4): Menu ↔ VeterinaryClinic ↔ Database
#
# Actions map to the sequence diagram steps:
#   index  → initial "Find a Clinic" request; location resolution
#   search → db.execute(clinicSearchQuery) + sortByDistance + filter
#   show   → showDetailCard(clinic)
# =============================================================================
class ClinicsController < ApplicationController

  # ---------------------------------------------------------------------------
  # GET /clinics
  # Renders the search landing page (location prompt + filter controls).
  # Corresponds to: m.selectFindClinic() → db.execute(locationQuery)
  # ---------------------------------------------------------------------------
  def index
    @species_list         = VeterinaryClinic::SPECIES_LIST
    @availability_filters = VeterinaryClinic::AVAILABILITY_FILTERS

    @lat     = params[:lat].presence&.to_f
    @lng     = params[:lng].presence&.to_f
    @filters = build_filters

    return unless @lat && @lng

    all_clinics    = VeterinaryClinic.all_active
    result         = VeterinaryClinic.search_with_radius_expansion(all_clinics, @lat, @lng, @filters)
    @clinics       = result[:clinics]
    @radius_km     = result[:radius_used]
    @show_helpline = @clinics.empty?
  end

  # ---------------------------------------------------------------------------
  # GET /clinics/search
  # Core search action:
  #   1. Resolve user location (lat/lng from params or manual entry)
  #   2. Load all active clinics from DB
  #   3. Apply VeterinaryClinic.search_with_radius_expansion (sorts + filters)
  #   4. Render sorted, filtered list to view
  # ---------------------------------------------------------------------------
  def search
    @lat     = params[:lat].presence&.to_f
    @lng     = params[:lng].presence&.to_f
    @filters = build_filters

    if @lat.nil? || @lng.nil?
      flash.now[:alert] = "Please allow location access or enter your location manually."
      @clinics   = []
      @radius_km = nil
      render :index and return
    end

    all_clinics = VeterinaryClinic.all_active   # delegates to DB / seed store

    result     = VeterinaryClinic.search_with_radius_expansion(all_clinics, @lat, @lng, @filters)
    @clinics   = result[:clinics]
    @radius_km = result[:radius_used]

    # Surface emergency helpline when no results remain after expansion (SRS 1a).
    @show_helpline = @clinics.empty?

    respond_to do |format|
      format.html
      format.json { render json: clinics_json(@clinics, @lat, @lng) }
    end
  end

  # ---------------------------------------------------------------------------
  # GET /clinics/:id
  # Detail card: name, address, phone, hours, emergency status, navigate link.
  # Corresponds to: showDetailCard(clinic) in sequence diagram.
  # ---------------------------------------------------------------------------
  def show
    @clinic = VeterinaryClinic.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @clinic.detail_summary }
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to clinics_path, alert: "Clinic not found."
  end

  # ---------------------------------------------------------------------------
  private
  # ---------------------------------------------------------------------------

  # Builds the filter hash expected by VeterinaryClinic.apply_filters.
  def build_filters
    {
      open_now:       params[:open_now]       == "1",
      emergency_24_7: params[:emergency_24_7] == "1",
      species:        params[:species].presence
    }
  end

  # Serialises clinic list for the JSON API (used by JS map / AJAX refresh).
  def clinics_json(clinics, lat, lng)
    clinics.map do |c|
      c.detail_summary.merge(
        distance_km: c.distance_to(lat, lng).round(1),
        open_now:    c.open_now?,
        todays_hours: c.todays_hours
      )
    end
  end
end