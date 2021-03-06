package com {
    import org.flixel.FlxText;
    import org.flixel.FlxSprite;
    import org.flixel.FlxTilemap;
    import org.flixel.FlxPoint;
    import org.flixel.FlxGroup;
    import flash.utils.Dictionary;
    public class BaseLevel {
        public var masterLayer : FlxGroup;
        public var hitTilemaps : FlxGroup;
        public var tilemaps : FlxGroup;
        public static var boundsMinX : Int;
        public static var boundsMinY : Int;
        public static var boundsMaxX : Int;
        public static var boundsMaxY : Int;
        public var boundsMin : FlxPoint;
        public var boundsMax : FlxPoint;
        public var bgColor : UInt;
        public var paths : Array;
        public var shapes : Array;
        public static var linkedObjectDictionary : Dictionary = new Dictionary ();
        public function new () {
            shapes = [];
            paths = [];
            bgColor = 0;
            tilemaps = new FlxGroup ();
            hitTilemaps = new FlxGroup ();
            masterLayer = new FlxGroup ();
            super ();
            if (Std.is (a, Fuck)) {
            }
        }

        public function createObjects (onAddCallback : Dynamic = null, parentObject : Object = null) : Void {
        }

        public function addTilemap (mapClass : Class, imageClass : Class, xpos : Float, ypos : Float, tileWidth : UInt,
          tileHeight : UInt, scrollX : Float, scrollY : Float, hits : Boolean, collideIdx : UInt, drawIdx : UInt, properties :
          Array, onAddCallback : Dynamic = null) : FlxTilemap {
            var map : FlxTilemap = new FlxTilemap ();
            var p = cast (map, Fuck);
            map.loadMap (Type.createInstance (mapClass, []), imageClass, tileWidth, tileHeight, FlxTilemap.OFF, 0, drawIdx,
              collideIdx);
            map.x = xpos;
            map.y = ypos;
            map.scrollFactor.x = scrollX;
            map.scrollFactor.y = scrollY;
            if (hits) hitTilemaps.add (map);
            tilemaps.add (map);
            if (onAddCallback != null) onAddCallback (map, null, this, scrollX, scrollY, properties);
            return map;
        }

        public function addSpriteToLayer (obj : FlxSprite, type : Class, layer : FlxGroup, xpos : Float, ypos : Float, angle :
          Float, scrollX : Float, scrollY : Float, flipped : Boolean = false, scaleX : Float = 1, scaleY : Float = 1, properties
          : Array = null, onAddCallback : Dynamic = null) : FlxSprite {
            if (obj == null) obj = Type.createInstance (classObject, [xpos, ypos]);
            obj.x += obj.offset.x;
            obj.y += obj.offset.y;
            obj.angle = angle;
            if (scaleX != 1 || scaleY != 1) {
                obj.scale.x = scaleX;
                obj.scale.y = scaleY;
                obj.width *= scaleX;
                obj.height *= scaleY;
                var newFrameWidth : Float = obj.frameWidth * scaleX;
                var newFrameHeight : Float = obj.frameHeight * scaleY;
                var hullOffsetX : Float = obj.offset.x * scaleX;
                var hullOffsetY : Float = obj.offset.y * scaleY;
                obj.offset.x -= (newFrameWidth - obj.frameWidth) / 2;
                obj.offset.y -= (newFrameHeight - obj.frameHeight) / 2;
            }
            if (obj.facing == FlxObject.RIGHT) obj.facing = flipped ? FlxObject.LEFT : FlxObject.RIGHT;
            obj.scrollFactor.x = scrollX;
            obj.scrollFactor.y = scrollY;
            layer.add (obj);
            callbackNewData (obj, onAddCallback, layer, properties, scrollX, scrollY, false);
            return obj;
        }

        public function addTextToLayer (textdata : TextData, layer : FlxGroup, scrollX : Float, scrollY : Float, embed : Boolean
          , properties : Array, onAddCallback : Dynamic) : FlxText {
            var textobj : FlxText = new FlxText (textdata.x, textdata.y, textdata.width, textdata.text, embed);
            textobj.setFormat (textdata.fontName, textdata.size, textdata.color, textdata.alignment);
            addSpriteToLayer (textobj, FlxText, layer, 0, 0, textdata.angle, scrollX, scrollY, false, 1, 1, properties,
              onAddCallback);
            textobj.height = textdata.height;
            textobj.origin.x = textobj.width * 0.5;
            textobj.origin.y = textobj.height * 0.5;
            return textobj;
        }

        protected function callbackNewData (data : Object, onAddCallback : Dynamic, layer : FlxGroup, properties : Array,
          scrollX : Float, scrollY : Float, needsReturnData : Boolean = false) : Object {
            if (onAddCallback != null) {
                var newData : Object = onAddCallback (data, layer, this, scrollX, scrollY, properties);
                if (newData != null) data = newData;
                else if (needsReturnData) trace (
                  "Error: callback needs to return either the object passed in or a new object to set up links correctly.");
            }
            return data;
        }

        protected function generateProperties (...arguments) : Array {
            var properties : Array = [];
            if (arguments.length) {
                for (var i : UInt = 0; i < arguments.length - 1; i ++) {
                    properties.push (arguments [i]);
                }
            }
            return properties;
        }

        public function createLink (objectFrom : Object, target : Object, onAddCallback : Dynamic, properties : Array) : Void {
            var link : ObjectLink = new ObjectLink (objectFrom, target);
            callbackNewData (link, onAddCallback, null, properties, objectFrom.scrollFactor.x, objectFrom.scrollFactor.y);
        }

        public function destroy () : Void {
            masterLayer.destroy ();
            masterLayer = null;
            tilemaps = null;
            hitTilemaps = null;
            var i : UInt;
            for (i = 0; i < paths.length; i ++) {
                var pathobj : Object = paths [i];
                if (pathobj) {
                    pathobj.destroy ();
                }
            }
            paths = null;
            for (i = 0; i < shapes.length; i ++) {
                var shape : Object = shapes [i];
                if (shape) {
                    shape.destroy ();
                }
            }
            shapes = null;
        }

        private static var level_FirstStep : Level_FirstStep;
        private static var level_Teaching : Level_Teaching;
        private static var level_EasyGo : Level_EasyGo;
        private static var level_Hall : Level_Hall;
        private static var level_ElecDoor : Level_ElecDoor;
        private static var level_LongJump : Level_LongJump;
        private static var level_Passage : Level_Passage;
        private static var level_Passage_new : Level_Passage_new;
        private static var level_MachineDoors : Level_MachineDoors;
        private static var level_Trap : Level_Trap;
        private static var level_DarkRoom : Level_DarkRoom;
        private static var level_Frustrated : Level_Frustrated;
        private static var level_Locked : Level_Locked;
        private static var level_SoManyDoors : Level_SoManyDoors;
        private static var level_Box : Level_Box;
        private static var level_OneBox : Level_OneBox;
        private static var level_Drop : Level_Drop;
        private static var level_Autolock : Level_Autolock;
        private static var level_Shooter : Level_Shooter;
        private static var level_Final : Level_Final;
    }
}
