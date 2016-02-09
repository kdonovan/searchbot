module Searchbot::Utils::Parsing

  def str2i(str)
    return unless str && str.to_s.strip.length > 0
    str.to_s.gsub(/[^\d.]/, '').to_i
  end

  def abbrev_to_state(abbrev)
    STATES[abbrev.upcase]
  end

  def state_to_abbrev(full_name)
    match = STATES.invert.detect {|full, abbrev| full.downcase == full_name.downcase }
    match && match[1]
  end

  def state_alt_display(state)
    if state.to_s.length == 2
      abbrev_to_state(state)
    else
      state_to_abbrev(state)
    end
  end

  def state_abbrev(state)
    return state if state.to_s.length == 2
    state_to_abbrev(state)
  end

  STATES = {
    'AK' => "Alaska",
    'AL' => "Alabama",
    'AR' => "Arkansas",
    'AS' => "American Samoa",
    'AZ' => "Arizona",
    'CA' => "California",
    'CO' => "Colorado",
    'CT' => "Connecticut",
    'DC' => "District of Columbia",
    'DE' => "Delaware",
    'FL' => "Florida",
    'GA' => "Georgia",
    'GU' => "Guam",
    'HI' => "Hawaii",
    'IA' => "Iowa",
    'ID' => "Idaho",
    'IL' => "Illinois",
    'IN' => "Indiana",
    'KS' => "Kansas",
    'KY' => "Kentucky",
    'LA' => "Louisiana",
    'MA' => "Massachusetts",
    'MD' => "Maryland",
    'ME' => "Maine",
    'MI' => "Michigan",
    'MN' => "Minnesota",
    'MO' => "Missouri",
    'MS' => "Mississippi",
    'MT' => "Montana",
    'NC' => "North Carolina",
    'ND' => "North Dakota",
    'NE' => "Nebraska",
    'NH' => "New Hampshire",
    'NJ' => "New Jersey",
    'NM' => "New Mexico",
    'NV' => "Nevada",
    'NY' => "New York",
    'OH' => "Ohio",
    'OK' => "Oklahoma",
    'OR' => "Oregon",
    'PA' => "Pennsylvania",
    'PR' => "Puerto Rico",
    'RI' => "Rhode Island",
    'SC' => "South Carolina",
    'SD' => "South Dakota",
    'TN' => "Tennessee",
    'TX' => "Texas",
    'UT' => "Utah",
    'VA' => "Virginia",
    'VI' => "Virgin Islands",
    'VT' => "Vermont",
    'WA' => "Washington",
    'WI' => "Wisconsin",
    'WV' => "West Virginia",
    'WY' => "Wyoming"
  }

end