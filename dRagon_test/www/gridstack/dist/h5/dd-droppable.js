"use strict";
/**
 * dd-droppable.ts 4.2.3
 * Copyright (c) 2021 Alain Dumesny - see GridStack root license
 */
Object.defineProperty(exports, "__esModule", { value: true });
const dd_manager_1 = require("./dd-manager");
const dd_base_impl_1 = require("./dd-base-impl");
const dd_utils_1 = require("./dd-utils");
class DDDroppable extends dd_base_impl_1.DDBaseImplement {
    constructor(el, opts = {}) {
        super();
        this.el = el;
        this.option = opts;
        // create var event binding so we can easily remove and still look like TS methods (unlike anonymous functions)
        this._dragEnter = this._dragEnter.bind(this);
        this._dragOver = this._dragOver.bind(this);
        this._dragLeave = this._dragLeave.bind(this);
        this._drop = this._drop.bind(this);
        this.el.classList.add('ui-droppable');
        this.el.addEventListener('dragenter', this._dragEnter);
        this._setupAccept();
    }
    on(event, callback) {
        super.on(event, callback);
    }
    off(event) {
        super.off(event);
    }
    enable() {
        if (!this.disabled)
            return;
        super.enable();
        this.el.classList.remove('ui-droppable-disabled');
        this.el.addEventListener('dragenter', this._dragEnter);
    }
    disable(forDestroy = false) {
        if (this.disabled)
            return;
        super.disable();
        if (!forDestroy)
            this.el.classList.add('ui-droppable-disabled');
        this.el.removeEventListener('dragenter', this._dragEnter);
    }
    destroy() {
        if (this.moving) {
            this._removeLeaveCallbacks();
        }
        this.disable(true);
        this.el.classList.remove('ui-droppable');
        this.el.classList.remove('ui-droppable-disabled');
        delete this.moving;
        super.destroy();
    }
    updateOption(opts) {
        Object.keys(opts).forEach(key => this.option[key] = opts[key]);
        this._setupAccept();
        return this;
    }
    /** @internal called when the cursor enters our area - prepare for a possible drop and track leaving */
    _dragEnter(event) {
        if (!this._canDrop())
            return;
        event.preventDefault();
        if (this.moving)
            return; // ignore multiple 'dragenter' as we go over existing items
        this.moving = true;
        const ev = dd_utils_1.DDUtils.initEvent(event, { target: this.el, type: 'dropover' });
        if (this.option.over) {
            this.option.over(ev, this._ui(dd_manager_1.DDManager.dragElement));
        }
        this.triggerEvent('dropover', ev);
        this.el.addEventListener('dragover', this._dragOver);
        this.el.addEventListener('drop', this._drop);
        this.el.addEventListener('dragleave', this._dragLeave);
        this.el.classList.add('ui-droppable-over');
    }
    /** @internal called when an moving to drop item is being dragged over - do nothing but eat the event */
    _dragOver(event) {
        event.preventDefault();
        event.stopPropagation();
    }
    /** @internal called when the item is leaving our area, stop tracking if we had moving item */
    _dragLeave(event) {
        // ignore leave events on our children (get when starting to drag our items)
        // Note: Safari Mac has null relatedTarget which causes #1684 so check if DragEvent is inside the grid instead
        if (!event.relatedTarget) {
            const { bottom, left, right, top } = this.el.getBoundingClientRect();
            if (event.x < right && event.x > left && event.y < bottom && event.y > top)
                return;
        }
        else if (this.el.contains(event.relatedTarget))
            return;
        this._removeLeaveCallbacks();
        if (this.moving) {
            event.preventDefault();
            const ev = dd_utils_1.DDUtils.initEvent(event, { target: this.el, type: 'dropout' });
            if (this.option.out) {
                this.option.out(ev, this._ui(dd_manager_1.DDManager.dragElement));
            }
            this.triggerEvent('dropout', ev);
        }
        delete this.moving;
    }
    /** @internal item is being dropped on us - call the client drop event */
    _drop(event) {
        if (!this.moving)
            return; // should not have received event...
        event.preventDefault();
        const ev = dd_utils_1.DDUtils.initEvent(event, { target: this.el, type: 'drop' });
        if (this.option.drop) {
            this.option.drop(ev, this._ui(dd_manager_1.DDManager.dragElement));
        }
        this.triggerEvent('drop', ev);
        this._removeLeaveCallbacks();
        delete this.moving;
    }
    /** @internal called to remove callbacks when leaving or dropping */
    _removeLeaveCallbacks() {
        this.el.removeEventListener('dragleave', this._dragLeave);
        this.el.classList.remove('ui-droppable-over');
        if (this.moving) {
            this.el.removeEventListener('dragover', this._dragOver);
            this.el.removeEventListener('drop', this._drop);
        }
        // Note: this.moving is reset by callee of this routine to control the flow
    }
    /** @internal */
    _canDrop() {
        return dd_manager_1.DDManager.dragElement && (!this.accept || this.accept(dd_manager_1.DDManager.dragElement.el));
    }
    /** @internal */
    _setupAccept() {
        if (this.option.accept && typeof this.option.accept === 'string') {
            this.accept = (el) => {
                return el.matches(this.option.accept);
            };
        }
        else {
            this.accept = this.option.accept;
        }
        return this;
    }
    /** @internal */
    _ui(drag) {
        return Object.assign({ draggable: drag.el }, drag.ui());
    }
}
exports.DDDroppable = DDDroppable;
//# sourceMappingURL=dd-droppable.js.map