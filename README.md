# Describe how the combat works

My combat is a rhythm-based combat. It works on the principles of this children's game: [https://www.hranostaj.cz/hra4083](https://www.hranostaj.cz/hra4083). During combat, you press keys in sync with the rhythm playing in the background. To make it easier, there are falling signals and a square target, and when they meet, that's the moment to press a key. The combat has two phases: **clap** and **action**.

- **Clap Phase**:  
  You press the spacebar twice, on the beat. If you miss either of these claps or press any key other than `SPACE`, no actions in the second phase will work.  

- **Action Phase**:  
  You can choose one of three actions, each mapped to a different key:  
  - **LEFT ARROW / A** → reload  
  - **UP ARROW / W** → defend  
  - **RIGHT ARROW / D** → shoot  

  You need to press the same action key twice in each phase for the action to work. Reloading gives you one ammo, and you can only shoot if you have that ammo. If you defend or both you and the enemy shoot at the same time, no health is lost.

---

# Describe where players can find quests

The first quest comes from an NPC inside a house. After talking to them, a woman appears outside, below the house. You’ll need to fight her to earn 1000 coins, which you then give to the NPC inside. Completing this quest unlocks the next quest: a lady NPC appears to the left of the house and tells you to fight the cacti farmer, who’s in the desert on the right side of the map. After beating him, you get a cactus item, which you give to the lady near the house. Completing this quest unlocks a new ability—starting fights with a loaded ammo.

Enemies don’t disappear after fights, so you can replay the combat minigame as much as you want. (I could’ve made them disappear, but in this state, I thought it was more fun to keep them around.)

---

# Describe what you added to make your game stand out from other solutions

The rhythm-based combat system was my main focus, especially with all its mechanics and logic. I’m also happy with the quest system—I think the way I coded it turned out pretty well (you can set callables so that you can have different conditions and rewards, etc., for quests). Another thing I’m happy about is the floating damage numbers from the cacti. Getting them to gradually shrink was very tricky, but they look pretty cool now.
