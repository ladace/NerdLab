package com {
    import org.flixel.*;
    import flash.utils.Dictionary;
    import sprites.*;
    import events.*;
    class BaseLevel {
        var masterLayer : FlxGroup = new FlxGroup;
        var hitTilemaps : FlxGroup = new FlxGroup;
        var tilemaps : FlxGroup = new FlxGroup;
        static var boundsMinX : int;
        static var boundsMinY : int;
        static var boundsMaxX : int;
        static var boundsMaxY : int;
        var boundsMin : FlxPoint;
        var boundsMax : FlxPoint;
        var bgColor : uint = 0;
        var paths : Array = [];
        var shapes : Array = [];
        static var linkedObjectDictionary : Dictionary = new Dictionary;
        function new () {
        }

        function createObjects (onAddCallback : Function = null, parentObject : Object = null) : void {
        }

        function addTilemap (mapClass : Class, imageClass : Class, xpos : Number, ypos : Number, tileWidth : uint, tileHeight :
          uint, scrollX : Number, scrollY : Number, hits : Boolean, collideIdx : uint, drawIdx : uint, properties : Array,
          onAddCallback : Function = null) : FlxTilemap {
            var map : FlxTilemap = new FlxTilemap;
            var p = Fuck (map);
            map.loadMap (new mapClass, imageClass, tileWidth, tileHeight, FlxTilemap.OFF, 0, drawIdx, collideIdx);
            map.x = xpos;
            map.y = ypos;
            map.scrollFactor.x = scrollX;
            map.scrollFactor.y = scrollY;
            if (hits) hitTilemaps.add (map);
            tilemaps.add (map);
            if (onAddCallback != null) onAddCallback (map, null, this, scrollX, scrollY, properties);
            return map;
        }

        function addSpriteToLayer (obj : FlxSprite, type : Class, layer : FlxGroup, xpos : Number, ypos : Number, angle : Number
          , scrollX : Number, scrollY : Number, flipped : Boolean = false, scaleX : Number = 1, scaleY : Number = 1, properties
          : Array = null, onAddCallback : Function = null) : FlxSprite {
            if (obj == null) obj = new type (xpos, ypos);
            obj.x += obj.offset.x;
            obj.y += obj.offset.y;
            obj.angle = angle;
            if (scaleX != 1 || scaleY != 1) {
                obj.scale.x = scaleX;
                obj.scale.y = scaleY;
                obj.width *= scaleX;
                obj.height *= scaleY;
                var newFrameWidth : Number = obj.frameWidth * scaleX;
                var newFrameHeight : Number = obj.frameHeight * scaleY;
                var hullOffsetX : Number = obj.offset.x * scaleX;
                var hullOffsetY : Number = obj.offset.y * scaleY;
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

        function addTextToLayer (textdata : TextData, layer : FlxGroup, scrollX : Number, scrollY : Number, embed : Boolean,
          properties : Array, onAddCallback : Function) : FlxText {
            var textobj : FlxText = new FlxText (textdata.x, textdata.y, textdata.width, textdata.text, embed);
            textobj.setFormat (textdata.fontName, textdata.size, textdata.color, textdata.alignment);
            addSpriteToLayer (textobj, FlxText, layer, 0, 0, textdata.angle, scrollX, scrollY, false, 1, 1, properties,
              onAddCallback);
            textobj.height = textdata.height;
            textobj.origin.x = textobj.width * 0.5;
            textobj.origin.y = textobj.height * 0.5;
            return textobj;
        }

        function callbackNewData (data : Object, onAddCallback : Function, layer : FlxGroup, properties : Array, scrollX :
          Number, scrollY : Number, needsReturnData : Boolean = false) : Object {
            if (onAddCallback != null) {
                var newData : Object = onAddCallback (data, layer, this, scrollX, scrollY, properties);
                if (newData != null) data = newData;
                else if (needsReturnData) trace (
                  "Error: callback needs to return either the object passed in or a new object to set up links correctly.");
            }
            return data;
        }

        function generateProperties (...arguments) : Array {
            var properties : Array = [];
            if (arguments.length) {
                for (var i : uint = 0; i < arguments.length - 1; i ++) {
                    properties.push (arguments [i]);
                }
            }
            return properties;
        }

        function createLink (objectFrom : Object, target : Object, onAddCallback : Function, properties : Array) : void {
            var link : ObjectLink = new ObjectLink (objectFrom, target);
            callbackNewData (link, onAddCallback, null, properties, objectFrom.scrollFactor.x, objectFrom.scrollFactor.y);
        }

        function destroy () : void {
            masterLayer.destroy ();
            masterLayer = null;
            tilemaps = null;
            hitTilemaps = null;
            var i : uint;
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

        static var level_FirstStep : Level_FirstStep;
        static var level_Teaching : Level_Teaching;
        static var level_EasyGo : Level_EasyGo;
        static var level_Hall : Level_Hall;
        static var level_ElecDoor : Level_ElecDoor;
        static var level_LongJump : Level_LongJump;
        static var level_Passage : Level_Passage;
        static var level_Passage_new : Level_Passage_new;
        static var level_MachineDoors : Level_MachineDoors;
        static var level_Trap : Level_Trap;
        static var level_DarkRoom : Level_DarkRoom;
        static var level_Frustrated : Level_Frustrated;
        static var level_Locked : Level_Locked;
        static var level_SoManyDoors : Level_SoManyDoors;
        static var level_Box : Level_Box;
        static var level_OneBox : Level_OneBox;
        static var level_Drop : Level_Drop;
        static var level_Autolock : Level_Autolock;
        static var level_Shooter : Level_Shooter;
        static var level_Final : Level_Final;
    }
}
