"use strict";
/**
 * dd-resizable.ts 4.2.3
 * Copyright (c) 2021 Alain Dumesny - see GridStack root license
 */
Object.defineProperty(exports, "__esModule", { value: true });
const dd_resizable_handle_1 = require("./dd-resizable-handle");
const dd_base_impl_1 = require("./dd-base-impl");
const dd_utils_1 = require("./dd-utils");
const utils_1 = require("../utils");
class DDResizable extends dd_base_impl_1.DDBaseImplement {
    constructor(el, opts = {}) {
        super();
        /** @internal */
        this._showHandlers = () => {
            this.el.classList.remove('ui-resizable-autohide');
        };
        /** @internal */
        this._hideHandlers = () => {
            this.el.classList.add('ui-resizable-autohide');
        };
        /** @internal */
        this._ui = () => {
            const containmentEl = this.el.parentElement;
            const containmentRect = containmentEl.getBoundingClientRect();
            const newRect = {
                width: this.originalRect.width,
                height: this.originalRect.height + this.scrolled,
                left: this.originalRect.left,
                top: this.originalRect.top - this.scrolled
            };
            const rect = this.temporalRect || newRect;
            return {
                position: {
                    left: rect.left - containmentRect.left,
                    top: rect.top - containmentRect.top
                },
                size: {
                    width: rect.width,
                    height: rect.height
                }
                /* Gridstack ONLY needs position set above... keep around in case.
                element: [this.el], // The object representing the element to be resized
                helper: [], // TODO: not support yet - The object representing the helper that's being resized
                originalElement: [this.el],// we don't wrap here, so simplify as this.el //The object representing the original element before it is wrapped
                originalPosition: { // The position represented as { left, top } before the resizable is resized
                  left: this.originalRect.left - containmentRect.left,
                  top: this.originalRect.top - containmentRect.top
                },
                originalSize: { // The size represented as { width, height } before the resizable is resized
                  width: this.originalRect.width,
                  height: this.originalRect.height
                }
                */
            };
        };
        this.el = el;
        this.option = opts;
        this.enable();
        this._setupAutoHide();
        this._setupHandlers();
    }
    on(event, callback) {
        super.on(event, callback);
    }
    off(event) {
        super.off(event);
    }
    enable() {
        super.enable();
        this.el.classList.add('ui-resizable');
        this.el.classList.remove('ui-resizable-disabled');
    }
    disable() {
        super.disable();
        this.el.classList.add('ui-resizable-disabled');
        this.el.classList.remove('ui-resizable');
    }
    destroy() {
        this._removeHandlers();
        if (this.option.autoHide) {
            this.el.removeEventListener('mouseover', this._showHandlers);
            this.el.removeEventListener('mouseout', this._hideHandlers);
        }
        this.el.classList.remove('ui-resizable');
        delete this.el;
        super.destroy();
    }
    updateOption(opts) {
        let updateHandles = (opts.handles && opts.handles !== this.option.handles);
        let updateAutoHide = (opts.autoHide && opts.autoHide !== this.option.autoHide);
        Object.keys(opts).forEach(key => this.option[key] = opts[key]);
        if (updateHandles) {
            this._removeHandlers();
            this._setupHandlers();
        }
        if (updateAutoHide) {
            this._setupAutoHide();
        }
        return this;
    }
    /** @internal */
    _setupAutoHide() {
        if (this.option.autoHide) {
            this.el.classList.add('ui-resizable-autohide');
            // use mouseover/mouseout instead of mouseenter/mouseleave to get better performance;
            this.el.addEventListener('mouseover', this._showHandlers);
            this.el.addEventListener('mouseout', this._hideHandlers);
        }
        else {
            this.el.classList.remove('ui-resizable-autohide');
            this.el.removeEventListener('mouseover', this._showHandlers);
            this.el.removeEventListener('mouseout', this._hideHandlers);
        }
        return this;
    }
    /** @internal */
    _setupHandlers() {
        let handlerDirection = this.option.handles || 'e,s,se';
        if (handlerDirection === 'all') {
            handlerDirection = 'n,e,s,w,se,sw,ne,nw';
        }
        this.handlers = handlerDirection.split(',')
            .map(dir => dir.trim())
            .map(dir => new dd_resizable_handle_1.DDResizableHandle(this.el, dir, {
            start: (event) => {
                this._resizeStart(event);
            },
            stop: (event) => {
                this._resizeStop(event);
            },
            move: (event) => {
                this._resizing(event, dir);
            }
        }));
        return this;
    }
    /** @internal */
    _resizeStart(event) {
        this.originalRect = this.el.getBoundingClientRect();
        this.scrollEl = utils_1.Utils.getScrollElement(this.el);
        this.scrollY = this.scrollEl.scrollTop;
        this.startEvent = event;
        this._setupHelper();
        this._applyChange();
        const ev = dd_utils_1.DDUtils.initEvent(event, { type: 'resizestart', target: this.el });
        if (this.option.start) {
            this.option.start(ev, this._ui());
        }
        this.el.classList.add('ui-resizable-resizing');
        this.triggerEvent('resizestart', ev);
        return this;
    }
    /** @internal */
    _resizing(event, dir) {
        this.scrolled = this.scrollEl.scrollTop - this.scrollY;
        this.temporalRect = this._getChange(event, dir);
        this._applyChange();
        const ev = dd_utils_1.DDUtils.initEvent(event, { type: 'resize', target: this.el });
        if (this.option.resize) {
            this.option.resize(ev, this._ui());
        }
        this.triggerEvent('resize', ev);
        return this;
    }
    /** @internal */
    _resizeStop(event) {
        const ev = dd_utils_1.DDUtils.initEvent(event, { type: 'resizestop', target: this.el });
        if (this.option.stop) {
            this.option.stop(ev); // Note: ui() not used by gridstack so don't pass
        }
        this.el.classList.remove('ui-resizable-resizing');
        this.triggerEvent('resizestop', ev);
        this._cleanHelper();
        delete this.startEvent;
        delete this.originalRect;
        delete this.temporalRect;
        delete this.scrollY;
        delete this.scrolled;
        return this;
    }
    /** @internal */
    _setupHelper() {
        this.elOriginStyleVal = DDResizable._originStyleProp.map(prop => this.el.style[prop]);
        this.parentOriginStylePosition = this.el.parentElement.style.position;
        if (window.getComputedStyle(this.el.parentElement).position.match(/static/)) {
            this.el.parentElement.style.position = 'relative';
        }
        this.el.style.position = this.option.basePosition || 'absolute'; // or 'fixed'
        this.el.style.opacity = '0.8';
        this.el.style.zIndex = '1000';
        return this;
    }
    /** @internal */
    _cleanHelper() {
        DDResizable._originStyleProp.forEach((prop, i) => {
            this.el.style[prop] = this.elOriginStyleVal[i] || null;
        });
        this.el.parentElement.style.position = this.parentOriginStylePosition || null;
        return this;
    }
    /** @internal */
    _getChange(event, dir) {
        const oEvent = this.startEvent;
        const newRect = {
            width: this.originalRect.width,
            height: this.originalRect.height + this.scrolled,
            left: this.originalRect.left,
            top: this.originalRect.top - this.scrolled
        };
        const offsetX = event.clientX - oEvent.clientX;
        const offsetY = event.clientY - oEvent.clientY;
        if (dir.indexOf('e') > -1) {
            newRect.width += offsetX;
        }
        else if (dir.indexOf('w') > -1) {
            newRect.width -= offsetX;
            newRect.left += offsetX;
        }
        if (dir.indexOf('s') > -1) {
            newRect.height += offsetY;
        }
        else if (dir.indexOf('n') > -1) {
            newRect.height -= offsetY;
            newRect.top += offsetY;
        }
        const constrain = this._constrainSize(newRect.width, newRect.height);
        if (Math.round(newRect.width) !== Math.round(constrain.width)) { // round to ignore slight round-off errors
            if (dir.indexOf('w') > -1) {
                newRect.left += newRect.width - constrain.width;
            }
            newRect.width = constrain.width;
        }
        if (Math.round(newRect.height) !== Math.round(constrain.height)) {
            if (dir.indexOf('n') > -1) {
                newRect.top += newRect.height - constrain.height;
            }
            newRect.height = constrain.height;
        }
        return newRect;
    }
    /** @internal constrain the size to the set min/max values */
    _constrainSize(oWidth, oHeight) {
        const maxWidth = this.option.maxWidth || Number.MAX_SAFE_INTEGER;
        const minWidth = this.option.minWidth || oWidth;
        const maxHeight = this.option.maxHeight || Number.MAX_SAFE_INTEGER;
        const minHeight = this.option.minHeight || oHeight;
        const width = Math.min(maxWidth, Math.max(minWidth, oWidth));
        const height = Math.min(maxHeight, Math.max(minHeight, oHeight));
        return { width, height };
    }
    /** @internal */
    _applyChange() {
        let containmentRect = { left: 0, top: 0, width: 0, height: 0 };
        if (this.el.style.position === 'absolute') {
            const containmentEl = this.el.parentElement;
            const { left, top } = containmentEl.getBoundingClientRect();
            containmentRect = { left, top, width: 0, height: 0 };
        }
        if (!this.temporalRect)
            return this;
        Object.keys(this.temporalRect).forEach(key => {
            const value = this.temporalRect[key];
            this.el.style[key] = value - containmentRect[key] + 'px';
        });
        return this;
    }
    /** @internal */
    _removeHandlers() {
        this.handlers.forEach(handle => handle.destroy());
        delete this.handlers;
        return this;
    }
}
exports.DDResizable = DDResizable;
/** @internal */
DDResizable._originStyleProp = ['width', 'height', 'position', 'left', 'top', 'opacity', 'zIndex'];
//# sourceMappingURL=dd-resizable.js.map