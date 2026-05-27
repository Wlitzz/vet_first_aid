FirstAidProcedure.destroy_all

# --- DOG CHOKING ---
dog_choke = FirstAidProcedure.create!(
  name: "Dog Choking",
  species: "dog",
  severity: "immediate",
  description: "A dog that is choking may paw at its mouth, make exaggerated swallowing motions, or become cyanotic (blue gums). Act quickly but calmly. If the dog loses consciousness, begin rescue breathing and contact an emergency vet immediately.",
  symptom_keywords: "choking, pawing at mouth, blue gums, gagging, difficulty breathing, cyanosis, retching, foreign object"
)

Step.create!([
  {
    first_aid_procedure: dog_choke, position: 1,
    instruction: "Restrain your dog calmly. Kneel beside or behind them. Open their mouth gently and look inside - if you can clearly see and safely reach the object, carefully sweep it out with one finger. Do NOT perform a blind finger sweep.",
    checklist: "Object is visible and reachable without pushing it deeper\nDog is not biting down due to panic\nIf unsure or unable to see the object, move to the next step immediately\nIf unsure, contact an emergency vet clinic immediately"
  },
  {
    first_aid_procedure: dog_choke, position: 2,
    instruction: "Perform the modified Heimlich maneuver. For a standing dog: stand or kneel behind the dog, place your hands around the abdomen just below the ribcage, and give 3-5 firm upward-and-forward thrusts. For a small dog: hold them on your lap facing away from you and apply gentle firm thrusts.",
    checklist: "Thrusts are applied below the ribcage, not on the ribcage\nApplying 3-5 firm but controlled compressions\nDo not apply excessive force on a small dog - this can cause internal injury\nIf unsure, contact an emergency vet clinic immediately"
  },
  {
    first_aid_procedure: dog_choke, position: 3,
    instruction: "After each set of thrusts, check the mouth again. Tilt the dog's head back slightly to open the airway and look for the object. If visible and reachable, carefully remove it. Repeat Heimlich thrusts and checks up to 3 times.",
    checklist: "Dog is showing signs of breathing improvement (sides moving, panting)\nGums are returning to pink colour from blue\nObject has been dislodged or removed\nIf unsure, contact an emergency vet clinic immediately"
  },
  {
    first_aid_procedure: dog_choke, position: 4,
    instruction: "Even if the obstruction is cleared, take your dog to a vet immediately. Internal bruising or a partial obstruction may not be visible. If the dog has lost consciousness, begin rescue breathing: close the mouth, breathe into the nose every 3 seconds while transporting to the vet.",
    checklist: "Dog is conscious and breathing on its own\nGums are pink\nDog has been assessed by a vet after the episode\nIf unsure, contact an emergency vet clinic immediately"
  }
])

InstructionalVideo.create!(
  first_aid_procedure: dog_choke,
  title: "How to Help a Choking Dog - Pet First Aid",
  url: "https://www.youtube.com/watch?v=NhYwzPJRqsk",
  description: "Demonstration of the modified Heimlich manoeuvre and choking response for dogs."
)

# --- CAT BLEEDING WOUND ---
cat_bleed = FirstAidProcedure.create!(
  name: "Cat Bleeding Wound",
  species: "cat",
  severity: "immediate",
  description: "Bleeding wounds in cats can result from bites, cuts, or trauma. Control bleeding with direct pressure before transporting to a vet. Severe blood loss is life-threatening - do not delay veterinary care.",
  symptom_keywords: "bleeding, wound, cut, laceration, blood, bite, trauma, injury, puncture"
)

steps_cat = Step.create!([
  {
    first_aid_procedure: cat_bleed, position: 1,
    instruction: "Keep yourself safe first - an injured, frightened cat may scratch or bite. Wrap the cat gently in a large towel to restrain it, leaving the wound accessible. Speak calmly and avoid sudden movements.",
    checklist: "Cat is wrapped securely but not so tightly it cannot breathe\nYou have protective covering (towel or gloves) for your hands\nIf unsure, contact an emergency vet clinic immediately"
  },
  {
    first_aid_procedure: cat_bleed, position: 2,
    instruction: "Apply firm, direct pressure to the wound using a clean cloth, gauze pad, or sanitary pad. Press firmly and hold continuously for at least 3-5 minutes without lifting the cloth. If blood soaks through, add more material on top - do NOT remove the first layer.",
    checklist: "Pressure is being held continuously without releasing\nBlood is not soaking through rapidly (if it is, press harder)\nWound site is not on the neck or chest (seek emergency vet immediately if so)\nIf unsure, contact an emergency vet clinic immediately"
  },
  {
    first_aid_procedure: cat_bleed, position: 3,
    instruction: "Once bleeding slows or stops, secure the dressing loosely with a bandage or strips of cloth. Do NOT wrap too tightly - you should be able to slide two fingers under the bandage. Check for circulation: the area below the bandage should remain warm.",
    checklist: "Bandage is secure but not cutting off circulation\nSkin below bandage is warm and not turning blue or cold\nCat is not chewing at the bandage - use an e-collar if available\nIf unsure, contact an emergency vet clinic immediately"
  },
  {
    first_aid_procedure: cat_bleed, position: 4,
    instruction: "Transport to a vet clinic immediately, even if bleeding appears controlled. All wounds carry infection risk and may require sutures, antibiotics, or pain management. Keep the cat warm and calm during transport.",
    checklist: "Cat is transported in a secure carrier or wrapped in a towel\nWound dressing is in place and not leaking heavily\nVet clinic has been contacted and is expecting you\nIf unsure, contact an emergency vet clinic immediately"
  }
])

InstructionalVideo.create!(
  step: steps_cat[1],
  title: "How to Stop Bleeding in Cats - Pet First Aid",
  url: "https://www.youtube.com/watch?v=EfpNKRnWvAM",
  description: "Demonstration of direct pressure wound care for cats."
)

# --- RABBIT GI STASIS ---
rabbit_gi = FirstAidProcedure.create!(
  name: "Rabbit Not Eating (GI Stasis)",
  species: "rabbit",
  severity: "consult_vet_soon",
  description: "Gastrointestinal (GI) stasis is a common and potentially fatal condition in rabbits where the digestive system slows or stops. A rabbit that stops eating or producing droppings for more than 12 hours requires urgent veterinary attention.",
  symptom_keywords: "not eating, no droppings, GI stasis, gut stasis, lethargy, hunched posture, grinding teeth, bloated, stomach, digestive"
)

Step.create!([
  {
    first_aid_procedure: rabbit_gi, position: 1,
    instruction: "Check for droppings in the enclosure. Normal rabbit droppings are round, firm, and plentiful. If droppings are absent, very small, misshapen, or strung together with fur, the gut may be slowing down. Note when the rabbit last ate and when droppings were last seen.",
    checklist: "Droppings are present in the enclosure (reassuring sign)\nRabbit has eaten hay in the last 6 hours\nRabbit is not showing signs of pain: teeth grinding, hunched posture, reluctance to move\nIf no droppings for 12+ hours, contact a rabbit-savvy vet immediately"
  },
  {
    first_aid_procedure: rabbit_gi, position: 2,
    instruction: "Encourage gentle movement. Mild exercise (supervised free-roaming) can help stimulate gut motility. Offer fresh hay - timothy hay is preferred - as the primary food source. Do NOT offer treats, pellets, or high-sugar vegetables as substitutes. Ensure the rabbit can reach fresh water easily.",
    checklist: "Rabbit is moving around, even slowly\nFresh hay has been offered and is accessible\nRabbit is not bloated (abdomen should not feel tight or drum-like)\nIf bloated, do not massage - seek vet immediately\nIf unsure, contact an emergency vet clinic immediately"
  },
  {
    first_aid_procedure: rabbit_gi, position: 3,
    instruction: "Do NOT attempt to administer medication, oil, or home remedies without veterinary guidance - these can be harmful to rabbits. Keep the rabbit warm (18-24 degrees C) as hypothermia worsens GI stasis. Contact a rabbit-savvy vet as soon as possible for proper diagnosis and treatment.",
    checklist: "Rabbit has been kept warm and in a quiet, low-stress environment\nNo unprescribed medications or oils have been given\nA vet appointment has been booked - do not wait more than 12-24 hours from symptom onset\nIf unsure, contact an emergency vet clinic immediately"
  }
])

# --- HAMSTER SEIZURE ---
hamster_sz = FirstAidProcedure.create!(
  name: "Hamster Seizure",
  species: "hamster",
  severity: "immediate",
  description: "Seizures in hamsters can be caused by epilepsy, head injury, infection, low blood sugar, or toxic exposure. A seizing hamster may convulse, twitch, fall over, or appear rigid. Do not restrain the hamster during a seizure.",
  symptom_keywords: "seizure, convulsion, twitching, shaking, falling over, rigid, unresponsive, epilepsy, fit, tremor"
)

Step.create!([
  {
    first_aid_procedure: hamster_sz, position: 1,
    instruction: "Do NOT restrain or pick up the hamster while it is seizing - this can cause injury to the hamster and yourself. Remove any objects from the enclosure that could cause injury (water bottle, wheel, hides with sharp edges). Pad the area around the hamster with a soft cloth if possible.",
    checklist: "Hamster has not been picked up during the seizure\nSharp objects have been cleared from the immediate area\nEnvironment is quiet - turn off loud music, reduce bright lights\nIf unsure, contact an emergency vet clinic immediately"
  },
  {
    first_aid_procedure: hamster_sz, position: 2,
    instruction: "Time the seizure. Most brief seizures last under 60 seconds. Note the time it started. If the seizure lasts more than 2 minutes (status epilepticus), this is a medical emergency - contact a vet immediately while keeping the hamster warm and undisturbed.",
    checklist: "Seizure lasted less than 60 seconds (reassuring)\nHamster is beginning to regain awareness and movement after the seizure\nIf seizure lasted more than 2 minutes, contact a vet immediately\nIf unsure, contact an emergency vet clinic immediately"
  },
  {
    first_aid_procedure: hamster_sz, position: 3,
    instruction: "After the seizure ends, the hamster may be confused, wobbly, or temporarily unresponsive - this is the post-ictal phase and is normal. Keep the hamster warm (place a heat pad set to low under one half of the enclosure so it can move away if too warm). Offer a tiny amount of diluted honey water on your fingertip to rule out low blood sugar. Contact a vet for a full assessment.",
    checklist: "Hamster is recovering, moving, and becoming responsive\nHamster is kept warm but can move away from heat source\nNo further seizures have occurred in the last 30 minutes\nVet has been contacted for a follow-up assessment\nIf unsure, contact an emergency vet clinic immediately"
  }
])

InstructionalVideo.create!(
  first_aid_procedure: hamster_sz,
  title: "Hamster Seizures - What to Do",
  url: "https://www.youtube.com/watch?v=yD0fHvj3F8E",
  description: "Educational video on recognising and responding to hamster seizures."
)

puts "Seeded #{FirstAidProcedure.count} procedures, #{Step.count} steps, #{InstructionalVideo.count} videos."

# --- VETERINARY CLINICS ---
VeterinaryClinic.destroy_all

VeterinaryClinic.create!([
  {
    name: "Kuching Veterinary Clinic",
    address: "123 Jalan Padungan, Kuching, Sarawak",
    latitude: 1.5497,
    longitude: 110.3592,
    phone: "+60 82-123456",
    open_hours: "Mon:08:00-18:00,Tue:08:00-18:00,Wed:08:00-18:00,Thu:08:00-18:00,Fri:08:00-18:00,Sat:09:00-13:00",
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
    open_hours: "Mon:00:00-23:59,Tue:00:00-23:59,Wed:00:00-23:59,Thu:00:00-23:59,Fri:00:00-23:59,Sat:00:00-23:59,Sun:00:00-23:59",
    is_emergency: true,
    accepted_species: "Dog,Cat",
    last_verified_at: Date.today
  }
])
