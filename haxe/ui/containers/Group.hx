package haxe.ui.containers;

import haxe.ui.behaviours.DataBehaviour;
import haxe.ui.components.OptionBox;
import haxe.ui.core.Component;
import haxe.ui.core.CompositeBuilder;
import haxe.ui.core.InteractiveComponent;
import haxe.ui.events.UIEvent;
import haxe.ui.util.GUID;

@:composite(Builder)
class Group extends Box {
    //***********************************************************************************************************
    // Public API
    //***********************************************************************************************************
    @:clonable @:behaviour(DataBehaviour, "group" + GUID.uuid())     public var componentGroup:String;
}

//***********************************************************************************************************
// Composite Builder
//***********************************************************************************************************
@:dox(hide) @:noCompletion
private class Builder extends CompositeBuilder {
    private var _group:Group;

    public function new(group:Group) {
        super(group);
        _group = group;
    }

    public override function addComponent(child:Component):Component { // addComponentAt too
        childAdd(child);

        return super.addComponent(child);
    }

    public override function addComponentAt(child:Component, index:Int):Component { // addComponentAt too
        childAdd(child);

        return super.addComponentAt(child, index);
    }

    private function childAdd(child:Component) {
        if ((child is InteractiveComponent)) {
            processGroupChild(child);
        } else {
            var interactiveChildren = child.findComponents(InteractiveComponent);
            for (interactiveChild in interactiveChildren) {
                processGroupChild(interactiveChild);
            }
        }
    }

    private function processGroupChild(child:Component) {
        if ((child is OptionBox)) {
            // set group name
            if (_group.componentGroup == null) {
                _group.componentGroup = "group" + GUID.uuid();
            }
            cast(child, OptionBox).componentGroup = _group.componentGroup;
        }
        if (child.hasEvent(UIEvent.CHANGE, childChangeHandler) == false) {
            // attach change event
            child.registerEvent(UIEvent.CHANGE, childChangeHandler);
        }
    }

    private function childChangeHandler(e:UIEvent) {
        _group.dispatch(e.clone());
    }
}
