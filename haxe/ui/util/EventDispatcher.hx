package haxe.ui.util;

import haxe.ui.core.Component;
import haxe.ui.events.UIEvent;

class EventDispatcher<T:UIEvent> {
    private var _eventMap:EventMap = new EventMap();

    public function new() {
    }

    public function registerEvent<T:UIEvent>(type:String, listener:T->Void) {
        _eventMap.add(type, listener);
    }

    public function hasEvent<T:UIEvent>(type:String, listener:T->Void = null):Bool {
        return _eventMap.contains(type, listener);
    }

    public function unregisterEvent<T:UIEvent>(type:String, listener:T->Void) {
        _eventMap.remove(type, listener);
    }

    public function dispatch<T:UIEvent>(event:T, target:Component = null) {
        _eventMap.invoke(event.type, event, target);
    }

    public function removeAllListeners() {
        _eventMap.removeAll();
    }
}