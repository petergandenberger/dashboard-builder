"use strict";
/**
 * dd-draggable.ts 4.2.3
 * Copyright (c) 2021 Alain Dumesny - see GridStack root license
 */
Object.defineProperty(exports, "__esModule", { value: true });
const dd_manager_1 = require("./dd-manager");
const dd_utils_1 = require("./dd-utils");
const dd_base_impl_1 = require("./dd-base-impl");
class DDDraggable extends dd_base_impl_1.DDBaseImplement {
    constructor(el, option = {}) {
        super();
        /** @internal */
        this.dragging = false;
        /** @internal TODO: set to public as called by DDDroppable! */
        this.ui = () => {
            const containmentEl = this.el.parentElement;
            const containmentRect = containmentEl.getBoundingClientRect();
            const offset = this.helper.getBoundingClientRect();
            return {
                position: {
                    top: offset.top - containmentRect.top,
                    left: offset.left - containmentRect.left
                }
                /* not used by GridStack for now...
                helper: [this.helper], //The object arr representing the helper that's being dragged.
                offset: { top: offset.top, left: offset.left } // Current offset position of the helper as { top, left } object.
                */
            };
        };
        this.el = el;
        this.option = option;
        // get the element that is actually supposed to be dragged by
        let className = option.handle.substring(1);
        this.dragEl = el.classList.contains(className) ? el : el.querySelector(option.handle) || el;
        // create var event binding so we can easily remove and still look like TS methods (unlike anonymous functions)
        this._dragStart = this._dragStart.bind(this);
        this._drag = this._drag.bind(this);
        this._dragEnd = this._dragEnd.bind(this);
        this.enable();
    }
    on(event, callback) {
        super.on(event, callback);
    }
    off(event) {
        super.off(event);
    }
    enable() {
        super.enable();
        this.dragEl.draggable = true;
        this.dragEl.addEventListener('dragstart', this._dragStart);
        this.el.classList.remove('ui-draggable-disabled');
        this.el.classList.add('ui-draggable');
    }
    disable(forDestroy = false) {
        super.disable();
        this.dragEl.removeAttribute('draggable');
        this.dragEl.removeEventListener('dragstart', this._dragStart);
        this.el.classList.remove('ui-draggable');
        if (!forDestroy)
            this.el.classList.add('ui-draggable-disabled');
    }
    destroy() {
        if (this.dragging) {
            // Destroy while dragging should remove dragend listener and manually trigger
            // dragend, otherwise dragEnd can't perform dragstop because eventRegistry is
            // destroyed.
            this._dragEnd({});
        }
        this.disable(true);
        delete this.el;
        delete this.helper;
        delete this.option;
        super.destroy();
    }
    updateOption(opts) {
        Object.keys(opts).forEach(key => this.option[key] = opts[key]);
        return this;
    }
    /** @internal */
    _dragStart(event) {
        dd_manager_1.DDManager.dragElement = this;
        this.helper = this._createHelper(event);
        this._setupHelperContainmentStyle();
        this.dragOffset = this._getDragOffset(event, this.el, this.helperContainment);
        const ev = dd_utils_1.DDUtils.initEvent(event, { target: this.el, type: 'dragstart' });
        if (this.helper !== this.el) {
            this._setupDragFollowNodeNotifyStart(ev);
        }
        else {
            this.dragFollowTimer = window.setTimeout(() => {
                delete this.dragFollowTimer;
                this._setupDragFollowNodeNotifyStart(ev);
            }, 0);
        }
        this._cancelDragGhost(event);
    }
    /** @internal */
    _setupDragFollowNodeNotifyStart(ev) {
        this._setupHelperStyle();
        document.addEventListener('dragover', this._drag, DDDraggable.dragEventListenerOption);
        this.dragEl.addEventListener('dragend', this._dragEnd);
        if (this.option.start) {
            this.option.start(ev, this.ui());
        }
        this.dragging = true;
        this.helper.classList.add('ui-draggable-dragging');
        this.triggerEvent('dragstart', ev);
        return this;
    }
    /** @internal */
    _drag(event) {
        // Safari: prevent default to allow drop to happen instead of reverting back (with animation) and delaying dragend #1541
        // https://stackoverflow.com/questions/61760755/how-to-fire-dragend-event-immediately
        event.preventDefault();
        this._dragFollow(event);
        const ev = dd_utils_1.DDUtils.initEvent(event, { target: this.el, type: 'drag' });
        if (this.option.drag) {
            this.option.drag(ev, this.ui());
        }
        this.triggerEvent('drag', ev);
    }
    /** @internal */
    _dragEnd(event) {
        if (this.dragFollowTimer) {
            clearTimeout(this.dragFollowTimer);
            delete this.dragFollowTimer;
            return;
        }
        else {
            if (this.paintTimer) {
                cancelAnimationFrame(this.paintTimer);
            }
            document.removeEventListener('dragover', this._drag, DDDraggable.dragEventListenerOption);
            this.dragEl.removeEventListener('dragend', this._dragEnd);
        }
        this.dragging = false;
        this.helper.classList.remove('ui-draggable-dragging');
        this.helperContainment.style.position = this.parentOriginStylePosition || null;
        if (this.helper === this.el) {
            this._removeHelperStyle();
        }
        else {
            this.helper.remove();
        }
        const ev = dd_utils_1.DDUtils.initEvent(event, { target: this.el, type: 'dragstop' });
        if (this.option.stop) {
            this.option.stop(ev); // Note: ui() not used by gridstack so don't pass
        }
        this.triggerEvent('dragstop', ev);
        delete dd_manager_1.DDManager.dragElement;
        delete this.helper;
    }
    /** @internal create a clone copy (or user defined method) of the original drag item if set */
    _createHelper(event) {
        let helper = this.el;
        if (typeof this.option.helper === 'function') {
            helper = this.option.helper(event);
        }
        else if (this.option.helper === 'clone') {
            helper = dd_utils_1.DDUtils.clone(this.el);
        }
        if (!document.body.contains(helper)) {
            dd_utils_1.DDUtils.appendTo(helper, this.option.appendTo === 'parent' ? this.el.parentNode : this.option.appendTo);
        }
        if (helper === this.el) {
            this.dragElementOriginStyle = DDDraggable.originStyleProp.map(prop => this.el.style[prop]);
        }
        return helper;
    }
    /** @internal */
    _setupHelperStyle() {
        this.helper.style.pointerEvents = 'none';
        this.helper.style.width = this.dragOffset.width + 'px';
        this.helper.style.height = this.dragOffset.height + 'px';
        this.helper.style.willChange = 'left, top';
        this.helper.style.transition = 'none'; // show up instantly
        this.helper.style.position = this.option.basePosition || DDDraggable.basePosition;
        this.helper.style.zIndex = '1000';
        setTimeout(() => {
            if (this.helper) {
                this.helper.style.transition = null; // recover animation
            }
        }, 0);
        return this;
    }
    /** @internal */
    _removeHelperStyle() {
        // don't bother restoring styles if we're gonna remove anyway...
        let node = this.helper ? this.helper.gridstackNode : undefined;
        if (!node || !node._isAboutToRemove) {
            DDDraggable.originStyleProp.forEach(prop => {
                this.helper.style[prop] = this.dragElementOriginStyle[prop] || null;
            });
        }
        delete this.dragElementOriginStyle;
        return this;
    }
    /** @internal */
    _dragFollow(event) {
        if (this.paintTimer) {
            cancelAnimationFrame(this.paintTimer);
        }
        this.paintTimer = requestAnimationFrame(() => {
            delete this.paintTimer;
            const offset = this.dragOffset;
            let containmentRect = { left: 0, top: 0 };
            if (this.helper.style.position === 'absolute') {
                const { left, top } = this.helperContainment.getBoundingClientRect();
                containmentRect = { left, top };
            }
            this.helper.style.left = event.clientX + offset.offsetLeft - containmentRect.left + 'px';
            this.helper.style.top = event.clientY + offset.offsetTop - containmentRect.top + 'px';
        });
    }
    /** @internal */
    _setupHelperContainmentStyle() {
        this.helperContainment = this.helper.parentElement;
        if (this.option.basePosition !== 'fixed') {
            this.parentOriginStylePosition = this.helperContainment.style.position;
            if (window.getComputedStyle(this.helperContainment).position.match(/static/)) {
                this.helperContainment.style.position = 'relative';
            }
        }
        return this;
    }
    /** @internal prevent the default gost image to be created (which has wrongas we move the helper/element instead
     * (legacy jquery UI code updates the top/left of the item).
     * TODO: maybe use mouse event instead of HTML5 drag as we have to work around it anyway, or change code to not update
     * the actual grid-item but move the gost image around (and special case jq version) ?
     **/
    _cancelDragGhost(e) {
        /* doesn't seem to do anything...
        let t = e.dataTransfer;
        t.effectAllowed = 'none';
        t.dropEffect = 'none';
        t.setData('text', '');
        */
        // NOTE: according to spec (and required by Safari see #1540) the image has to be visible in the browser (in dom and not hidden) so make it a 1px div
        let img = document.createElement('div');
        img.style.width = '1px';
        img.style.height = '1px';
        document.body.appendChild(img);
        e.dataTransfer.setDragImage(img, 0, 0);
        setTimeout(() => document.body.removeChild(img)); // nuke once drag had a chance to grab this 'image'
        e.stopPropagation();
        return this;
    }
    /** @internal */
    _getDragOffset(event, el, parent) {
        // in case ancestor has transform/perspective css properties that change the viewpoint
        let xformOffsetX = 0;
        let xformOffsetY = 0;
        if (parent) {
            const testEl = document.createElement('div');
            dd_utils_1.DDUtils.addElStyles(testEl, {
                opacity: '0',
                position: 'fixed',
                top: 0 + 'px',
                left: 0 + 'px',
                width: '1px',
                height: '1px',
                zIndex: '-999999',
            });
            parent.appendChild(testEl);
            const testElPosition = testEl.getBoundingClientRect();
            parent.removeChild(testEl);
            xformOffsetX = testElPosition.left;
            xformOffsetY = testElPosition.top;
            // TODO: scale ?
        }
        const targetOffset = el.getBoundingClientRect();
        return {
            left: targetOffset.left,
            top: targetOffset.top,
            offsetLeft: -event.clientX + targetOffset.left - xformOffsetX,
            offsetTop: -event.clientY + targetOffset.top - xformOffsetY,
            width: targetOffset.width,
            height: targetOffset.height
        };
    }
}
exports.DDDraggable = DDDraggable;
/** @internal */
DDDraggable.basePosition = 'absolute';
/** @internal #1541 can't have {passive: true} on Safari as otherwise it reverts animate back to old location on drop */
DDDraggable.dragEventListenerOption = true; // DDUtils.isEventSupportPassiveOption ? { capture: true, passive: true } : true;
/** @internal */
DDDraggable.originStyleProp = ['transition', 'pointerEvents', 'position',
    'left', 'top', 'opacity', 'zIndex', 'width', 'height', 'willChange'];
//# sourceMappingURL=dd-draggable.js.map