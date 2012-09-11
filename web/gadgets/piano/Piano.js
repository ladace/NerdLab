function Piano() {
    var freq_ratio = Math.exp(Math.log(2)/12);
    var freq_ratio2 = Math.sqrt(2);

    var octave_ar = [0, 1, 0, 3, 0, 0, 1, 0, 2, 0, 3, 0];//0 refers to white keys; 1 2 3 refer to black keys, and suggest the offsets.
    var key_map = ['Z', 'S', 'X', 'D', 'C', 'V', 'G', 'B', 'H', 'N', 'J', 'M',
    'Q', '2', 'W', '3', 'E', 'R', '5', 'T', '6', 'Y', '7', 'U',
    'I', '9', 'O', '0', 'P', String.fromCharCode(219), String.fromCharCode(187), String.fromCharCode(221)];

    var isMouseDown = false;//mouse down boolean
    var isKeyDown = [];

    var generator = new WaveGenerator([0.7, 0.2, 0.1, 0.05], 1.2);

    function Note(freq) {
        this.audio = generator.createWaveSound(freq);
        this.play = function() {
            this.audio.play();
            this.audio.currentTime = this.audio.initialTime;
        }
    }

    function createKey(pos, note, css) {
        function highlight(who) {
            who.css('background', css.highlightColor);
        }
        function restore(who) {
            who.css('background', css.normalColor);
        }
        var element = $('<div class="' + css.cssClass + '"></div>').appendTo('#keyboard')

            .hover(
                    function(){
                        if (isMouseDown) {
                            note.play();
                        }
                        highlight($(this));
                    },
                    function(){restore($(this));})

            .mousedown(function() {
                note.play();
                isMouseDown = true;
                return false;})
            .css('left', pos * 20 + (css.offset == null ? 0 : css.offset))
            .mouseup(function(){ isMouseDown = false; });


        return {
            on_play: function() {
                highlight(element);
            },
            on_restore: function() {
                restore(element);
            }
        };
    }

    function createWhiteKey(pos, note) {
        return createKey(pos, note, {
            highlightColor: '#999',
            normalColor: 'white',
            cssClass: 'white-key'
        });
    }

    function createBlackKey(pos, note) {
        return createKey(pos, note, {
            highlightColor: '#555',
            normalColor: 'black',
            cssClass: 'black-key',
            offset: -6
        });
    }

    function createOctaveKeys(pos, base, from, end) {
        var notes = [];

        if(from == null) from = 0;
        if(end == null) end = 12;
        var freq = base;
        pos *= 7;

        for (var i = from; i < end; ++i) {
            var note = new Note(freq);
            notes.push(note);
            if (octave_ar[i] == 0) {
                note.graphics = createWhiteKey(pos++, note);
            } else {
                note.graphics = createBlackKey(pos, note, octave_ar[i] - 2);
            }
            freq *= freq_ratio;
        }

        return notes;
    }
    
    this.openKeyControl = function () {
        //add key event listeners
        window.addEventListener('keydown', (function(e) {
            var idx = key_map.indexOf(String.fromCharCode(e.which));
            if (idx != -1) {
                if (!isKeyDown[idx]) {
                    isKeyDown[idx] = true;

                    this.notes[idx + 12].graphics.on_play();
                    this.notes[idx + 12].play();
                }
                e.preventDefault();
            }
        }).bind(this), true);
        window.addEventListener('keyup', (function(e) {
            var idx = key_map.indexOf(String.fromCharCode(e.which));
            if (idx != -1) {
                isKeyDown[idx] = false;
                this.notes[idx + 12].graphics.on_restore();
                e.preventDefault();
            }
        }).bind(this), true);
    }

    this.notes = [];

    var freq = 110 * freq_ratio * freq_ratio * freq_ratio;
    for (var i = 0; i < 4; ++i) {
        this.notes = this.notes.concat(createOctaveKeys(i, freq));
        freq *= 2;
    }
    this.notes = this.notes.concat(createOctaveKeys(4, freq, 0, 5));

}

