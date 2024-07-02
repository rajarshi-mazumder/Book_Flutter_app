import 'package:book_frontend/models/books/book_details.dart';

var returnKingChapters = [
  {
    "chapter_1": "Minas Tirith",
    "content":
        "Gandalf and Pippin ride to Minas Tirith to warn Denethor of the impending attack by Sauron's forces. They prepare the city for siege, knowing that the fate of Gondor hangs in the balance. The shadow of war looms large as the armies of Mordor approach.",
    "audio_path": "path_to_audio_1"
  },
  {
    "chapter_2": "The Muster of Rohan",
    "content":
        "Théoden rallies the Rohirrim to ride to the aid of Gondor. Merry pledges his service to King Théoden, and the riders set out for Minas Tirith. The journey is fraught with anticipation and the knowledge that a great battle awaits them.",
    "audio_path": "path_to_audio_2"
  },
  {
    "chapter_3": "The Siege of Gondor",
    "content":
        "Sauron's forces lay siege to Minas Tirith. The defenders hold out bravely, but the overwhelming numbers of the enemy threaten to break their lines. Denethor, overcome by despair, loses hope, and the city's fate seems grim.",
    "audio_path": "path_to_audio_3"
  },
  {
    "chapter_4": "The Ride of the Rohirrim",
    "content":
        "As Minas Tirith falters, the Rohirrim arrive to turn the tide. They charge into battle, their arrival giving new hope to the defenders. Théoden leads his riders with courage, knowing that their bravery could save the city.",
    "audio_path": "path_to_audio_4"
  },
  {
    "chapter_5": "The Battle of the Pelennor Fields",
    "content":
        "The battle rages on the Pelennor Fields. Théoden falls in battle, but Éowyn and Merry defeat the Witch-king of Angmar. Aragorn arrives with reinforcements from the ships of the Dead, and the combined forces drive back Sauron's army.",
    "audio_path": "path_to_audio_5"
  },
  {
    "chapter_6": "The Pyre of Denethor",
    "content":
        "Denethor, driven mad by grief and despair, attempts to burn himself and Faramir alive. Gandalf intervenes, saving Faramir, but Denethor perishes. The event marks a turning point in the defense of Minas Tirith.",
    "audio_path": "path_to_audio_6"
  },
  {
    "chapter_7": "The Houses of Healing",
    "content":
        "Aragorn heals the wounded in the Houses of Healing, including Éowyn, Faramir, and Merry. His skills as a healer reveal his true identity as the rightful king. Hope is rekindled among the people of Gondor.",
    "audio_path": "path_to_audio_7"
  },
  {
    "chapter_8": "The Last Debate",
    "content":
        "The leaders of the Free Peoples debate their next move. They decide to march on the Black Gate to draw Sauron's eye away from Frodo and Sam. It is a desperate gamble, but they know it is their only chance to give the Ring-bearer time.",
    "audio_path": "path_to_audio_8"
  },
  {
    "chapter_9": "The Black Gate Opens",
    "content":
        "Aragorn leads the forces of Gondor and Rohan to the Black Gate of Mordor. They challenge Sauron, hoping to distract him from the Ring-bearer's mission. The battle is fierce, and they hold the line, awaiting a sign of success from Frodo.",
    "audio_path": "path_to_audio_9"
  },
  {
    "chapter_10": "Mount Doom",
    "content":
        "Frodo and Sam reach Mount Doom. Frodo, overcome by the Ring's power, claims it for himself. Gollum attacks, biting off Frodo's finger and falling into the fire with the Ring. Sauron is defeated, and the quest is fulfilled.",
    "audio_path": "path_to_audio_10"
  },
];

BookDetails returnKingDetails = BookDetails(
  bookId: "3",
  chapters: returnKingChapters,
);
