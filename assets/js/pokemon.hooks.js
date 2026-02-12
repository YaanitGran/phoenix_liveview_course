const BATTLE_SOUND = "/sounds/pokemon_battle.mp3";
const PokemonBattle = {
  mounted() {
    this.handleEvent("battle:start", (payload) => {
      this.playSound(BATTLE_SOUND, 5);
    });
  },
  playSound(src, duration) {
    const audio = new Audio(src);
    audio.duration = duration;
    audio.play();
  },
};

export default PokemonBattle;
