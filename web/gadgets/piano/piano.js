var freq_ratio = Math.exp(Math.log(2)/12);
var freq_ratio2 = Math.sqrt(2);

var octave_ar = [0, 1, 0, 3, 0, 0, 1, 0, 2, 0, 3, 0];//0 refers to white keys; 1 2 3 refer to black keys, and suggest the offsets.
var key_map = ['Z', 'S', 'X', 'D', 'C', 'V', 'G', 'B', 'H', 'N', 'J', 'M',
    'Q', '2', 'W', '3', 'E', 'R', '5', 'T', '6', 'Y', '7', 'U',
    'I', '9', 'O', '0', 'P', String.fromCharCode(219), String.fromCharCode(187), String.fromCharCode(221)];

var md = false;//mouse down boolean
var key_is_down = [];

var generator = new WaveGenerator([0.7, 0.2, 0.1, 0.05], 1.2);

function create_note(freq) {
    return {
        audio: generator.createWaveSound(freq),
        play: function() { this.audio.play(); this.audio.currentTime = this.audio.initialTime;}
    };
}

function clamp(level) {
    if (level < 0) return 0;
    if (level > 255) return 255;
    return Math.round(level);
}

function create_white_key(pos, note) {
    function highlight(who) {
        who.css('background', '#999');
    }
    function restore(who) {
        who.css('background', 'white');
    }
    var ele = $('<div class="white-key"></div>').appendTo('#keyboard')

        .hover(
                function(){
                    if (md) {
                        note.play();
                    }
                    highlight($(this));
                },
                function(){restore($(this));})

        .mousedown(function() {
            note.play();
            md = true;
            return false;})
        .css('left', pos * 20)
        .mouseup(function(){ md = false; });
    return {
        tag: ele,
            on_play: function() {
                highlight(this.tag);
            },
            on_restore: function() {
                            restore(this.tag);
                        }
    };
}

function create_black_key(pos, note, off) {
    function highlight(who) {
        who.css('background', '#555');
    }
    function restore(who) {
        who.css('background', 'black');
    }
    var ele = $('<div class="black-key"></div>').appendTo('#keyboard')

        .hover(
                function(){
                    if (md) {
                        note.play();
                    }
                    highlight($(this));
                },
                function(){restore($(this));})

        .mousedown(function() {
            note.play();
            md = true;
            return false;})
        .css('left', pos * 20 - 6 + off * 2)
        .mouseup(function(){ md = false; });

    return {
        tag: ele,
            on_play: function() {
                highlight(this.tag);
            },
            on_restore: function() {
                            restore(this.tag);
                        }
    };
}


function create_octave_key(pos, base, n) {
    var notes = [];

    if(n == null) n = 12;
    var freq = base;
    pos *= 7;

    var f = 6; if (n < 6) f = n;
    for (var i = 0; i < f; ++i) {
        var note = create_note(freq);
        notes.push(note);
        if (octave_ar[i] == 0) {
            note.graphics = create_white_key(pos++, note);
        } else {
            note.graphics = create_black_key(pos, note, octave_ar[i] - 2);
        }
        freq *= freq_ratio;
    }
    freq = base * freq_ratio2;
    for (var i = 6; i < n; ++i) {
        var note = create_note(freq);
        notes.push(note);
        if (octave_ar[i] == 0) {
            note.graphics = create_white_key(pos++, note);
        } else {
            note.graphics = create_black_key(pos, note, octave_ar[i] - 2);
        }
        freq *= freq_ratio;
    }
    return notes;
}

$(document).ready(function() {
    var error = false;

    try{
        var notes = [];
        var freq = 110 * freq_ratio * freq_ratio * freq_ratio;
        for (var i = 0; i < 4; ++i) {
            notes = notes.concat(create_octave_key(i, freq));
            freq *= 2;
        }
        notes = notes.concat(create_octave_key(4, freq, 5));

        //add key event listeners

        window.addEventListener('keydown', function(e) {
            var idx = key_map.indexOf(String.fromCharCode(e.which));
            if (idx != -1) {
                if (!key_is_down[idx]) {
                    key_is_down[idx] = true;

                    notes[idx + 12].graphics.on_play();
                    notes[idx + 12].play();
                }
                e.preventDefault();
            }
        }, true);
        window.addEventListener('keyup', function(e) {
            var idx = key_map.indexOf(String.fromCharCode(e.which));
            if (idx != -1) {
                key_is_down[idx] = false;
                notes[idx + 12].graphics.on_restore();
                e.preventDefault();
            }
        }, true);
    }catch (e) {
        error = true;
        throw e;
    }

    //detect the browser
    (function() {
        var str = navigator.userAgent.toLowerCase();
        function contain(name) {
            return str.indexOf(name) != -1;
        }
        if(error || (!(contain('chrome') || contain('firefox')))) {
            var warn = $('#warning').html('Your browser may not support this. Better use Chrome or Firefox instead.').hide().fadeIn(1000);
            $('<div id="hider">hide</div>').appendTo(warn).click(function() {
                warn.fadeOut(200);
            });
        }
    })();

});
