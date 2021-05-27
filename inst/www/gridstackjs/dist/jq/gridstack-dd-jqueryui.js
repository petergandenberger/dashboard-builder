"use strict";
function __export(m) {
    for (var p in m) if (!exports.hasOwnProperty(p)) exports[p] = m[p];
}
Object.defineProperty(exports, "__esModule", { value: true });
const gridstack_dd_1 = require("../gridstack-dd");
// export jq symbols see
// https://stackoverflow.com/questions/35345760/importing-jqueryui-with-typescript-and-requirejs
// https://stackoverflow.com/questions/33998262/jquery-ui-and-webpack-how-to-manage-it-into-module
//
// Note: user should be able to bring their own by changing their webpack aliases like
// alias: {
//   'jquery': 'gridstack/dist/jq/jquery.js',
//   'jquery-ui': 'gridstack/dist/jq/jquery-ui.js',
//   'jquery.ui': 'gridstack/dist/jq/jquery-ui.js',
//   'jquery.ui.touch-punch': 'gridstack/dist/jq/jquery.ui.touch-punch.js',
// },
const $ = require("jquery"); // compile this in... having issues TS/ES6 app would include instead
exports.$ = $;
require("jquery-ui");
require("jquery.ui.touch-punch"); // include for touch mobile devices
// export our base class (what user should use) and all associated types
__export(require("../gridstack-dd"));
/**
 * legacy Jquery-ui based drag'n'drop plugin.
 */
class GridStackDDJQueryUI extends gridstack_dd_1.GridStackDD {
    resizable(el, opts, key, value) {
        let $el = $(el);
        if (opts === 'enable') {
            $el.resizable().resizable(opts);
        }
        else if (opts === 'disable' || opts === 'destroy') {
            if ($el.data('ui-resizable')) { // error to call destroy if not there
                $el.resizable(opts);
            }
        }
        else if (opts === 'option') {
            $el.resizable(opts, key, value);
        }
        else {
            const grid = el.gridstackNode.grid;
            let handles = $el.data('gs-resize-handles') ? $el.data('gs-resize-handles') : grid.opts.resizable.handles;
            $el.resizable(Object.assign(Object.assign(Object.assign({}, grid.opts.resizable), { handles: handles }), {
                start: opts.start,
                stop: opts.stop,
                resize: opts.resize // || function() {}
            }));
        }
        return this;
    }
    draggable(el, opts, key, value) {
        let $el = $(el);
        if (opts === 'enable') {
            $el.draggable().draggable('enable');
        }
        else if (opts === 'disable' || opts === 'destroy') {
            if ($el.data('ui-draggable')) { // error to call destroy if not there
                $el.draggable(opts);
            }
        }
        else if (opts === 'option') {
            $el.draggable(opts, key, value);
        }
        else {
            const grid = el.gridstackNode.grid;
            $el.draggable(Object.assign(Object.assign({}, grid.opts.draggable), {
                containment: (grid.opts._isNested && !grid.opts.dragOut) ?
                    $(grid.el).parent() : (grid.opts.draggable.containment || null),
                start: opts.start,
                stop: opts.stop,
                drag: opts.drag // || function() {}
            }));
        }
        return this;
    }
    dragIn(el, opts) {
        let $el = $(el); // workaround Type 'string' is not assignable to type 'PlainObject<any>' - see https://github.com/DefinitelyTyped/DefinitelyTyped/issues/29312
        $el.draggable(opts);
        return this;
    }
    droppable(el, opts, key, value) {
        let $el = $(el);
        if (typeof opts.accept === 'function' && !opts._accept) {
            // convert jquery event to generic element
            opts._accept = opts.accept;
            opts.accept = ($el) => opts._accept($el.get(0));
        }
        $el.droppable(opts, key, value);
        return this;
    }
    isDroppable(el) {
        let $el = $(el);
        return Boolean($el.data('ui-droppable'));
    }
    isDraggable(el) {
        let $el = $(el);
        return Boolean($el.data('ui-draggable'));
    }
    isResizable(el) {
        let $el = $(el);
        return Boolean($el.data('ui-resizable'));
    }
    on(el, name, callback) {
        let $el = $(el);
        $el.on(name, (event, ui) => { return callback(event, ui.draggable ? ui.draggable[0] : event.target, ui.helper ? ui.helper[0] : null); });
        return this;
    }
    off(el, name) {
        let $el = $(el);
        $el.off(name);
        return this;
    }
}
exports.GridStackDDJQueryUI = GridStackDDJQueryUI;
// finally register ourself
gridstack_dd_1.GridStackDD.registerPlugin(GridStackDDJQueryUI);
//# sourceMappingURL=gridstack-dd-jqueryui.js.map