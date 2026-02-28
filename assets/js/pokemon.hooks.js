const BATTLE_SOUND = "/sounds/pokemon_battle.mp3";
const PokemonBattle = {
  battleData: null,
  battleSound: null,
  // Variable to store the countdown interval
  countdownInterval: null,

  mounted() {
    // server event
    this.handleEvent("battle:start", (payload) => {
      this.battleData = payload;
      this.battleSound = this.playSound(BATTLE_SOUND, 5);
    });
    // --- STEP 1: Handle Reset Event ---
    this.handleEvent("reset-client-side", () => {
      // 1. Stop all sounds
      if (this.battleSound) {
        this.battleSound.pause();
        this.battleSound.currentTime = 0;
      }
      
      // 2. Clear any active countdown
      if (this.countdownInterval) {
        clearInterval(this.countdownInterval);
      }

      // 3. Show all pokemons again (if they were hidden)
      this.el.querySelectorAll("[id$='-pokemon']").forEach(el => {
        el.style.display = "block";
        el.classList.remove("loser-animation", "winner-animation", "draw-animation");
      });

      console.log("Game visual state reset!");
    });
  },
  updated() {
    // client event
    const battleButton = document.getElementById("battle-button");
    battleButton?.removeEventListener("click", () => {
      this.battle();
    });
    battleButton?.addEventListener("click", () => {
      this.battle();
    });
  },
  playSound(src, duration) {
    const audio = new Audio(src);
    audio.duration = duration;
    audio.play();
    return audio;
  },
  applyBattleAnimation(player, animation) {
    const id = player.id + "-pokemon";
    this.el.querySelector(`#${id}`).classList.add(animation);
    this.playSound(`/sounds/${player.pokemon.name.toLowerCase()}_cry.mp3`, 2);
  },
  battle() {
  // 1. Initial Cleanup
  if (this.battleSound) this.battleSound.pause();
  if (this.countdownInterval) clearInterval(this.countdownInterval);

  const countdownEl = document.getElementById("battle-countdown");
  if (!countdownEl) return;

  // 2. Start state: Show "3" immediately
  let count = 3;
  countdownEl.innerText = count;
  countdownEl.style.display = "block";
  
  // Add a small pop animation via CSS if you have one
  countdownEl.classList.add("countdown-bounce");

  // 3. Optimized Interval
  this.countdownInterval = setInterval(() => {
    count--;

    if (count > 0) {
      countdownEl.innerText = count;
    } else if (count === 0) {
      countdownEl.innerText = "GO!";
      // Trigger animations EXACTLY when GO! appears to avoid lag perception
      this.revealResults(); 
    } else {
      // 4. Final Cleanup: Hide "GO!" after a brief moment
      clearInterval(this.countdownInterval);
      setTimeout(() => {
        countdownEl.style.display = "none";
        countdownEl.classList.remove("countdown-bounce");
      }, 500); 
    }
  }, 1000);
},

// Helper function to handle the animations after the countdown
revealResults() {
  // Check for Draw
  if (this.battleData.status == "draw") {
    this.el.classList.add("draw-animation");
  } else {
    // Apply loser animation first
    this.applyBattleAnimation(this.battleData.loser, "loser-animation");

    // Hide loser after 2 seconds
    setTimeout(() => {
      const loserId = this.battleData.loser.id + "-pokemon";
      const loserEl = this.el.querySelector(`#${loserId}`);
      if (loserEl) loserEl.style.display = "none";
    }, 2000);

    // Apply winner animation after a small delay
    setTimeout(() => {
      this.applyBattleAnimation(this.battleData.winner, "winner-animation");
    }, 2500);
  }
}
};

export default PokemonBattle;
