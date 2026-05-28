puts "Cleaning the database..."
FirstAidProcedure.destroy_all
VeterinaryClinic.destroy_all

species_list = ["dog", "cat", "rabbit", "hamster"]

# The 4 generic emergency templates
emergencies = [
  {
    type: "Choking",
    severity: "immediate",
    desc: "The animal is choking on a foreign object. Pawing at mouth, gagging, or difficulty breathing.",
    keywords: "choking, gagging, breathing, object, block, mouth, cyanosis",
    steps: [
      "Restrain the animal calmly to prevent panic.",
      "Check the mouth for visible obstructions. Do not perform a blind finger sweep.",
      "If the object is visible and safe to reach, gently remove it.",
      "Seek emergency veterinary care immediately."
    ]
  },
  {
    type: "Bleeding Wound",
    severity: "immediate",
    desc: "Active bleeding from a cut, bite, or puncture wound. Requires immediate pressure.",
    keywords: "bleeding, cut, wound, blood, bite, puncture, laceration",
    steps: [
      "Ensure your own safety first and restrain the animal gently.",
      "Apply firm, direct pressure to the wound with a clean cloth for 5 minutes.",
      "Do not remove the cloth if blood soaks through; add more layers on top.",
      "Transport to a vet immediately while maintaining pressure."
    ]
  },
  {
    type: "Suspected Poisoning",
    severity: "immediate",
    desc: "Ingestion of toxic plants, chemicals, or human foods. Symptoms include vomiting, drooling, or lethargy.",
    keywords: "poison, toxic, chemical, vomit, drool, lethargy, ingest",
    steps: [
      "Identify the suspected poison and estimate how much was ingested.",
      "Do NOT induce vomiting unless explicitly instructed by a veterinarian.",
      "Remove the animal from the source of the toxin.",
      "Call an emergency vet clinic immediately with the packaging in hand."
    ]
  },
  {
    type: "Heatstroke",
    severity: "consult_vet_soon",
    desc: "Overheating due to hot environments. Symptoms include excessive panting, lethargy, or collapsing.",
    keywords: "heat, stroke, panting, hot, sun, temperature, lethargy, collapse",
    steps: [
      "Move the animal to a cool, shaded, or air-conditioned area immediately.",
      "Apply cool (NOT ice-cold) water to their paws, belly, and ears.",
      "Offer cool drinking water, but do not force them to drink.",
      "Contact a vet for further observation as internal organ damage can occur."
    ]
  }
]

puts "Generating 16 Emergency Procedures..."

# Loop through every animal and every emergency to create 16 database entries
species_list.each do |species|
  emergencies.each do |emergency|
    procedure = FirstAidProcedure.create!(
      name: "#{species.capitalize} #{emergency[:type]}",
      species: species,
      severity: emergency[:severity],
      description: emergency[:desc],
      symptom_keywords: emergency[:keywords]
    )

    # Automatically generate the step-by-step instructions for each procedure
    emergency[:steps].each_with_index do |instruction, index|
      Step.create!(
        first_aid_procedure: procedure,
        position: index + 1,
        instruction: instruction,
        checklist: "Task completed safely."
      )
    end
  end
end

puts "Successfully seeded #{FirstAidProcedure.count} procedures and #{Step.count} steps."

# Re-seed the veterinary clinics
puts "Generating Clinics..."
VeterinaryClinic.create!([
  {
    name: "Kuching Veterinary Clinic",
    address: "123 Jalan Padungan, Kuching, Sarawak",
    latitude: 1.5497,
    longitude: 110.3592,
    phone: "+60 82-123456",
    open_hours: "Mon-Fri:08:00-18:00,Sat:09:00-13:00",
    is_emergency: false,
    accepted_species: "Dog,Cat,Rabbit,Hamster",
    last_verified_at: Date.today
  },
  {
    name: "24Hr Pet Emergency Centre",
    address: "45 Jalan Song, Kuching, Sarawak",
    latitude: 1.5321,
    longitude: 110.3712,
    phone: "+60 82-654321",
    open_hours: "Sun-Sat:00:00-23:59",
    is_emergency: true,
    accepted_species: "Dog,Cat",
    last_verified_at: Date.today
  }
])
puts "Database population complete!"

puts "Generating Quizzes and Questions..."
Quiz.destroy_all

# The Quiz Blueprints
quiz_blueprints = [
  { title: "Choking Emergencies", topic_key: "choking", icon: "🦴", type: "Choking" },
  { title: "Bleeding Control", topic_key: "bleeding", icon: "🩹", type: "Bleeding Wound" },
  { title: "Toxic Ingestions", topic_key: "poisoning", icon: "☠️", type: "Suspected Poisoning" },
  { title: "Heatstroke & Hyperthermia", topic_key: "heatstroke", icon: "🔥", type: "Heatstroke" }
]

# The Question Bank (Fake answers included!)
question_bank = {
  "Choking" => {
    "dog" => { prompt: "If your dog is choking but you cannot see the object, what should you do?", options: ["Perform a blind finger sweep", "Perform the modified Heimlich maneuver", "Pour water down their throat", "Hold them upside down by the tail"], correct: "Perform the modified Heimlich maneuver" },
    "cat" => { prompt: "Your cat is choking and panicking. What is the safest first step?", options: ["Pry its mouth open immediately", "Restrain it gently with a thick towel", "Offer it a tasty liquid treat", "Tap firmly on its nose"], correct: "Restrain it gently with a thick towel" },
    "rabbit" => { prompt: "A rabbit is choking. How should you safely examine them?", options: ["Hold them upside down by the ears", "Support their hindquarters and check the mouth", "Compress their delicate ribcage tightly", "Blow forcefully into their nose"], correct: "Support their hindquarters and check the mouth" },
    "hamster" => { prompt: "Your hamster appears to be choking. What is a common false alarm?", options: ["They are just sleeping with their eyes open", "Their cheek pouches are just completely stuffed with food", "They are hiccuping from drinking too fast", "They are trying to sing"], correct: "Their cheek pouches are just completely stuffed with food" }
  },
  "Bleeding Wound" => {
    "dog" => { prompt: "What is the first step to control severe bleeding on a dog's leg?", options: ["Apply a tight tourniquet immediately", "Apply firm, direct pressure with a clean cloth", "Wash the wound with hydrogen peroxide", "Leave it open to the air to clot"], correct: "Apply firm, direct pressure with a clean cloth" },
    "cat" => { prompt: "If blood soaks through the first bandage on a cat's wound, what should you do?", options: ["Remove it and start fresh", "Add more layers of bandage on top", "Loosen the bandage to let it breathe", "Apply ice directly to the wound"], correct: "Add more layers of bandage on top" },
    "rabbit" => { prompt: "Why must you be careful when bandaging a rabbit?", options: ["Their fur is too slippery for tape", "Their skin is extremely delicate and tears easily", "They are allergic to most medical cotton", "They will immediately fall asleep"], correct: "Their skin is extremely delicate and tears easily" },
    "hamster" => { prompt: "How should you apply pressure to a bleeding hamster?", options: ["With two hands squeezing firmly", "With a single finger using very gentle pressure", "By wrapping them tightly in an elastic bandage", "You should never apply pressure to a hamster"], correct: "With a single finger using very gentle pressure" }
  },
  "Suspected Poisoning" => {
    "dog" => { prompt: "Your dog ate chocolate. Should you induce vomiting at home?", options: ["Yes, immediately using salt water", "Only if explicitly instructed by a veterinarian", "Yes, by sticking a finger down their throat", "No, just let them sleep it off"], correct: "Only if explicitly instructed by a veterinarian" },
    "cat" => { prompt: "Which of these common household items is highly toxic to cats?", options: ["Cardboard boxes", "Catnip", "Lilies (the flower)", "Cooked chicken"], correct: "Lilies (the flower)" },
    "rabbit" => { prompt: "If a rabbit ingests a toxic plant, what symptom is a critical emergency?", options: ["Eating more hay than usual", "Gastrointestinal stasis (stopping eating/pooping)", "Sleeping stretched out", "Thumping their hind leg once"], correct: "Gastrointestinal stasis (stopping eating/pooping)" },
    "hamster" => { prompt: "What human food is surprisingly dangerous for hamsters?", options: ["Unsalted peanuts", "Almonds and apple seeds (contain cyanide traces)", "Plain boiled egg", "A small piece of cucumber"], correct: "Almonds and apple seeds (contain cyanide traces)" }
  },
  "Heatstroke" => {
    "dog" => { prompt: "Which of these is a primary sign of heatstroke in dogs?", options: ["Shivering and seeking blankets", "Excessive drooling, heavy panting, and glazed eyes", "A cold, wet nose", "Increased appetite"], correct: "Excessive drooling, heavy panting, and glazed eyes" },
    "cat" => { prompt: "Cats rarely pant. If your cat is open-mouth panting on a hot day, what does it mean?", options: ["They are relaxed", "They are trying to smell something", "It is a severe medical emergency", "They are thirsty"], correct: "It is a severe medical emergency" },
    "rabbit" => { prompt: "How do rabbits regulate their body temperature?", options: ["By sweating through their paws", "By panting like dogs", "Through the large blood vessels in their ears", "By shedding their fur instantly"], correct: "Through the large blood vessels in their ears" },
    "hamster" => { prompt: "How can you help cool a hot hamster safely?", options: ["Submerge them in an ice bath", "Place them in the freezer for 2 minutes", "Provide a ceramic tile cooled in the fridge for them to lie on", "Point a desk fan directly at them on high speed"], correct: "Provide a ceramic tile cooled in the fridge for them to lie on" }
  }
}

# The Generator Loop
quiz_blueprints.each do |bp|
  quiz = Quiz.create!(title: bp[:title], description: "Test your knowledge on #{bp[:type]}", icon: bp[:icon], topic_key: bp[:topic_key])
  
  ["dog", "cat", "rabbit", "hamster"].each do |species|
    procedure = FirstAidProcedure.find_by(name: "#{species.capitalize} #{bp[:type]}")
    data = question_bank[bp[:type]][species]
    
    QuizQuestion.create!(
      quiz: quiz,
      first_aid_procedure: procedure,
      prompt: data[:prompt],
      options: data[:options],
      correct_answer: data[:correct]
    )
  end
end

puts "Database population complete! Added #{Quiz.count} Quizzes and #{QuizQuestion.count} Questions."

puts "Generating Instructional Videos..."
InstructionalVideo.destroy_all

# Loop through every procedure and attach the standard YouTube link
FirstAidProcedure.all.each do |procedure|
  InstructionalVideo.create!(
    first_aid_procedure: procedure,
    title: "Emergency Demonstration: #{procedure.name}",
    url: "https://www.youtube.com/watch?v=cdRUFy7YBYc" # Standard link!
  )
end

puts "Database population complete! Added #{InstructionalVideo.count} Videos."