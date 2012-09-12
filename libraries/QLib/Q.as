class Q
{
    static private var updaters : Array.<Function> = new Array.<Function>;
    static public function animate(func : Function, varSel : Object = null) {
        if (varSel == null) updaters.push(func);
        else {
            updaters.push(function() {
                varSel.write(func(varSel.read()));
            });
            //TODO register varSel
        }
    }
    static public function linearTo(varSel : Object, target: Number, duration: Number = 0.5) {
        var startV = valSel.read();
        var velocity = (target - startV) / duration;
        animate(function (x) {
            if (velocity > 0 && x >= target
             || velocity < 0 && x <= target) {
                Q.stopThis();
                return target;
            }
            return x += velocity * Q.elapsed;
        }, varSel);
    }
    
    static public function tag(obj : Object, tag : String) {
    }

    static public function sel(obj : Object, field : String) {
        return {
            write: function(x) {
                obj[field] = x;
            },
            read: function() {
                return obj[field];
            }
        };
    }

    //should be invoked in the updater
    static private var _currentStopFlag : Boolean = false;
    static public function stopThis() {
        _currentStopFlag = true;
    }

    static public function update(speedFactor : Number = 1) {
        for (var i = 0; i < updaters.length; ++i) {
            _currentStopFlag = false;
            updaters[i]();
            if (_currentStopFlag) {//remove the updater
                //TODO unregister valSel
                updaters.slice(i);
                --i;
            }
        }
    }
}
