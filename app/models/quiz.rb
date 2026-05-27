class Quiz
  TOPICS = {
    "wound-care" => {
      title: "Wound Care & Bleeding",
      description: "Cuts, lacerations, and how to control bleeding safely.",
      icon: "🩹",
      questions: [
        {
          text: "Applying direct pressure is the first step to control bleeding in a pet.",
          type: :true_false,
          correct: "true"
        },
        {
          text: "What should you do if a bandage becomes soaked with blood?",
          type: :multiple_choice,
          options: [ "Remove it and start fresh", "Add more layers on top", "Loosen it to let it breathe", "Apply ice directly" ],
          correct: "Add more layers on top"
        },
        {
          text: "Hydrogen peroxide is safe to clean open wounds on dogs.",
          type: :true_false,
          correct: "false"
        },
        {
          text: "How long should you apply direct pressure before checking if bleeding has stopped?",
          type: :multiple_choice,
          options: [ "30 seconds", "1–2 minutes", "5 minutes", "10 minutes" ],
          correct: "5 minutes"
        },
        {
          text: "A tourniquet should always be your first choice for controlling limb bleeding.",
          type: :true_false,
          correct: "false"
        },
        {
          text: "If a foreign object is embedded in a wound, what should you do?",
          type: :multiple_choice,
          options: [ "Pull it out immediately", "Leave it in and seek vet care", "Push it deeper to stop bleeding", "Rinse it out with water" ],
          correct: "Leave it in and seek vet care"
        }
      ]
    },
    "choking-poisoning" => {
      title: "Choking & Poisoning",
      description: "Airway obstruction, toxic foods, plants, and household chemicals.",
      icon: "☠️",
      questions: [
        {
          text: "Grapes and raisins are toxic to dogs.",
          type: :true_false,
          correct: "true"
        },
        {
          text: "What is the correct technique for helping a choking dog?",
          type: :multiple_choice,
          options: [ "Firm back blows between shoulder blades", "Gentle pats on the side", "Shake the dog vigorously", "Turn the dog upside down" ],
          correct: "Firm back blows between shoulder blades"
        },
        {
          text: "Inducing vomiting at home is always safe when a pet has ingested a toxin.",
          type: :true_false,
          correct: "false"
        },
        {
          text: "If your pet ingests a toxin, what should you do first?",
          type: :multiple_choice,
          options: [ "Give milk to dilute it", "Make the pet vomit immediately", "Contact your vet or animal poison control", "Give activated charcoal at home" ],
          correct: "Contact your vet or animal poison control"
        },
        {
          text: "Xylitol (an artificial sweetener found in some gums and foods) is toxic to dogs.",
          type: :true_false,
          correct: "true"
        },
        {
          text: "When a dog is choking, you should reach into its mouth to remove the object.",
          type: :multiple_choice,
          options: [ "Yes, always", "No — only if the object is clearly visible and reachable", "No, never attempt this", "Yes, but only if the dog is small" ],
          correct: "No — only if the object is clearly visible and reachable"
        }
      ]
    },
    "burns-heatstroke" => {
      title: "Burns & Heatstroke",
      description: "Thermal burns, hyperthermia, and heat-related emergencies.",
      icon: "🔥",
      questions: [
        {
          text: "You should apply butter or toothpaste to soothe a pet's burn.",
          type: :true_false,
          correct: "false"
        },
        {
          text: "What is the correct first step for treating a minor burn on a pet?",
          type: :multiple_choice,
          options: [ "Apply ice directly to the burn", "Run cool (not cold) water over it for 10–20 minutes", "Cover with a dry cloth immediately", "Pop any blisters that form" ],
          correct: "Run cool (not cold) water over it for 10–20 minutes"
        },
        {
          text: "A dog can get heatstroke even if it is not in direct sunlight.",
          type: :true_false,
          correct: "true"
        },
        {
          text: "Which of the following is a sign of heatstroke in a dog?",
          type: :multiple_choice,
          options: [ "Shivering and trembling", "Excessive drooling and glazed eyes", "Dry nose and reduced appetite", "Increased energy and alertness" ],
          correct: "Excessive drooling and glazed eyes"
        },
        {
          text: "Ice-cold water is the best way to rapidly cool a pet suffering from heatstroke.",
          type: :true_false,
          correct: "false"
        },
        {
          text: "How should you cool a pet with heatstroke?",
          type: :multiple_choice,
          options: [ "Wrap in towels soaked in ice water", "Use cool (not cold) water and fan them", "Place them in a cold room immediately", "Give cold water to drink only" ],
          correct: "Use cool (not cold) water and fan them"
        }
      ]
    },
    "fractures-injuries" => {
      title: "Fractures & Injuries",
      description: "Broken bones, sprains, and safe transport techniques.",
      icon: "🦴",
      questions: [
        {
          text: "You should attempt to straighten a fractured limb before transporting the pet.",
          type: :true_false,
          correct: "false"
        },
        {
          text: "How should you transport a pet with a suspected spinal injury?",
          type: :multiple_choice,
          options: [ "Let them walk slowly on their own", "Carry them on a rigid flat surface", "Cradle them upright in your arms", "Use a soft blanket as a hammock" ],
          correct: "Carry them on a rigid flat surface"
        },
        {
          text: "A pet with a fracture will always cry out or show obvious signs of pain.",
          type: :true_false,
          correct: "false"
        },
        {
          text: "What is the best material for an improvised splint?",
          type: :multiple_choice,
          options: [ "Bandage alone", "Tape wrapped tightly around the limb", "Rigid material padded with soft material", "Soft cloth wrapped firmly" ],
          correct: "Rigid material padded with soft material"
        },
        {
          text: "Open fractures (where bone is visible through the skin) require immediate veterinary care.",
          type: :true_false,
          correct: "true"
        },
        {
          text: "Which sign may suggest a pet has an internal injury?",
          type: :multiple_choice,
          options: [ "Limping on one leg", "Pale gums and a swollen abdomen", "Excessive barking", "Increased thirst" ],
          correct: "Pale gums and a swollen abdomen"
        }
      ]
    }
  }.freeze

  attr_reader :topic_key

  def initialize(topic_key)
    @topic_key = topic_key
  end

  def self.topics
    TOPICS
  end

  def self.find(topic_key)
    TOPICS.key?(topic_key) ? new(topic_key) : nil
  end

  def data
    TOPICS[topic_key]
  end

  def title       = data[:title]
  def description = data[:description]
  def icon        = data[:icon]
  def questions   = data[:questions]

  def score(answers)
    questions.each_with_index.count { |q, i| answers[i.to_s] == q[:correct] }
  end

  def result_details(answers)
    questions.each_with_index.map do |q, i|
      { question: q, user_answer: answers[i.to_s], correct: answers[i.to_s] == q[:correct] }
    end
  end
end
