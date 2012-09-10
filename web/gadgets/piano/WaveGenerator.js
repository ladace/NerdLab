//written by Ladace
//NOTE: RIFFWAVE.js required
WaveGenerator = (function () {
    //constants
    var sampleRate = 8000;
    var pi2 = 2 * Math.PI;

    function WaveGenerator(harmonic, length) {
        this.harmonic = harmonic;
        this.length = length;

        this.primaryWave = function (freq) {
            var harmonic = this.harmonic;
            return function (t) {
                var level = 0;
                for (i in harmonic) {
                    level += harmonic[i] * 128 * Math.sin(t * pi2 * freq * (parseInt(i) + 1));
                }
                return level;
            };
        }
        this.volEnvelope = function (freq) {
            var length = this.length;
            var freqFac = (1 * Math.exp(-Math.sqrt(freq / 440)));
            return function (t) {
                return (t < length / 100
                    ? 100 / length * t //attack
                    : (length - t) / (length * 99 / 100)) //release

                    * freqFac;
            };
        }
        this.createWaveSound = function (freq) {
            var audio = new Audio();//require HTML5
            var data = [];
            var wave = new RIFFWAVE();
            var generator = this.primaryWave(freq);
            var env = this.volEnvelope(freq);

            var sampleLength = this.length * sampleRate;
            for (var i = 0; i < sampleLength; ++i)
                data[i] = 127 + generator(i / sampleRate) * env(i / sampleRate);

            wave.Make(data);
            audio.src = wave.dataURI;
            return audio;
        }
    }
    return WaveGenerator;
})();
