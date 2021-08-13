/*!
 * GridStack 4.2.3
 * https://gridstackjs.com/
 *
 * Copyright (c) 2021 Alain Dumesny
 * see root license https://github.com/gridstack/gridstack.js/tree/master/LICENSE
 */
import { GridStackEngine } from './gridstack-engine';
import { Utils } from './utils';
import { ColumnOptions, GridItemHTMLElement, GridStackElement, GridStackEventHandlerCallback, GridStackOptions, GridStackWidget, numberOrString, DDDragInOpt } from './types';
export * from './types';
export * from './utils';
export * from './gridstack-engine';
export * from './gridstack-ddi';
export interface GridHTMLElement extends HTMLElement {
    gridstack?: GridStack;
}
export declare type GridStackEvent = 'added' | 'change' | 'disable' | 'drag' | 'dragstart' | 'dragstop' | 'dropped' | 'enable' | 'removed' | 'resize' | 'resizestart' | 'resizestop';
/** Defines the coordinates of an object */
export interface MousePosition {
    top: number;
    left: number;
}
/** Defines the position of a cell inside the grid*/
export interface CellPosition {
    x: number;
    y: number;
}
/**
 * Main gridstack class - you will need to call `GridStack.init()` first to initialize your grid.
 * Note: your grid elements MUST have the following classes for the CSS layout to work:
 * @example
 * <div class="grid-stack">
 *   <div class="grid-stack-item">
 *     <div class="grid-stack-item-content">Item 1</div>
 *   </div>
 * </div>
 */
export declare class GridStack {
    /**
     * initializing the HTML element, or selector string, into a grid will return the grid. Calling it again will
     * simply return the existing instance (ignore any passed options). There is also an initAll() version that support
     * multiple grids initialization at once. Or you can use addGrid() to create the entire grid from JSON.
     * @param options grid options (optional)
     * @param elOrString element or CSS selector (first one used) to convert to a grid (default to '.grid-stack' class selector)
     *
     * @example
     * let grid = GridStack.init();
     *
     * Note: the HTMLElement (of type GridHTMLElement) will store a `gridstack: GridStack` value that can be retrieve later
     * let grid = document.querySelector('.grid-stack').gridstack;
     */
    static init(options?: GridStackOptions, elOrString?: GridStackElement): GridStack;
    /**
     * Will initialize a list of elements (given a selector) and return an array of grids.
     * @param options grid options (optional)
     * @param selector elements selector to convert to grids (default to '.grid-stack' class selector)
     *
     * @example
     * let grids = GridStack.initAll();
     * grids.forEach(...)
     */
    static initAll(options?: GridStackOptions, selector?: string): GridStack[];
    /**
     * call to create a grid with the given options, including loading any children from JSON structure. This will call GridStack.init(), then
     * grid.load() on any passed children (recursively). Great alternative to calling init() if you want entire grid to come from
     * JSON serialized data, including options.
     * @param parent HTML element parent to the grid
     * @param opt grids options used to initialize the grid, and list of children
     */
    static addGrid(parent: HTMLElement, opt?: GridStackOptions): GridStack;
    /** scoping so users can call GridStack.Utils.sort() for example */
    static Utils: typeof Utils;
    /** scoping so users can call new GridStack.Engine(12) for example */
    static Engine: typeof GridStackEngine;
    /** the HTML element tied to this grid after it's been initialized */
    el: GridHTMLElement;
    /** engine used to implement non DOM grid functionality */
    engine: GridStackEngine;
    /** grid options - public for classes to access, but use methods to modify! */
    opts: GridStackOptions;
    /**
     * Construct a grid item from the given element and options
     * @param el
     * @param opts
     */
    constructor(el: GridHTMLElement, opts?: GridStackOptions);
    /**
     * add a new widget and returns it.
     *
     * Widget will be always placed even if result height is more than actual grid height.
     * You need to use `willItFit()` before calling addWidget for additional check.
     * See also `makeWidget()`.
     *
     * @example
     * let grid = GridStack.init();
     * grid.addWidget({w: 3, content: 'hello'});
     * grid.addWidget('<div class="grid-stack-item"><div class="grid-stack-item-content">hello</div></div>', {w: 3});
     *
     * @param el  GridStackWidget (which can have content string as well), html element, or string definition to add
     * @param options widget position/size options (optional, and ignore if first param is already option) - see GridStackWidget
     */
    addWidget(els?: GridStackWidget | GridStackElement, options?: GridStackWidget): GridItemHTMLElement;
    /**
     * saves the current layout returning a list of widgets for serialization (with default to save content), which might include any nested grids.
     * Optionally you can also save the grid with options itself, so you can call the new GridStack.addGrid()
     * to recreate everything from scratch. GridStackOptions.children would then contain the widget list.
     */
    save(saveContent?: boolean, saveGridOpt?: boolean): GridStackWidget[] | GridStackOptions;
    /**
     * load the widgets from a list. This will call update() on each (matching by id) or add/remove widgets that are not there.
     *
     * @param layout list of widgets definition to update/create
     * @param addAndRemove boolean (default true) or callback method can be passed to control if and how missing widgets can be added/removed, giving
     * the user control of insertion.
     *
     * @example
     * see http://gridstackjs.com/demo/serialization.html
     **/
    load(layout: GridStackWidget[], addAndRemove?: boolean | ((g: GridStack, w: GridStackWidget, add: boolean) => GridItemHTMLElement)): GridStack;
    /**
     * Initializes batch updates. You will see no changes until `commit()` method is called.
     */
    batchUpdate(): GridStack;
    /**
     * Gets current cell height.
     */
    getCellHeight(forcePixel?: boolean): number;
    /**
     * Update current cell height - see `GridStackOptions.cellHeight` for format.
     * This method rebuilds an internal CSS style sheet.
     * Note: You can expect performance issues if call this method too often.
     *
     * @param val the cell height. If not passed (undefined), cells content will be made square (match width minus margin),
     * if pass 0 the CSS will be generated by the application instead.
     * @param update (Optional) if false, styles will not be updated
     *
     * @example
     * grid.cellHeight(100); // same as 100px
     * grid.cellHeight('70px');
     * grid.cellHeight(grid.cellWidth() * 1.2);
     */
    cellHeight(val?: numberOrString, update?: boolean): GridStack;
    /** Gets current cell width. */
    cellWidth(): number;
    /** return our expected width (or parent) for 1 column check */
    private _widthOrContainer;
    /**
     * Finishes batch updates. Updates DOM nodes. You must call it after batchUpdate.
     */
    commit(): GridStack;
    /** re-layout grid items to reclaim any empty space */
    compact(): GridStack;
    /**
     * set the number of columns in the grid. Will update existing widgets to conform to new number of columns,
     * as well as cache the original layout so you can revert back to previous positions without loss.
     * Requires `gridstack-extra.css` or `gridstack-extra.min.css` for [2-11],
     * else you will need to generate correct CSS (see https://github.com/gridstack/gridstack.js#change-grid-columns)
     * @param column - Integer > 0 (default 12).
     * @param layout specify the type of re-layout that will happen (position, size, etc...).
     * Note: items will never be outside of the current column boundaries. default (moveScale). Ignored for 1 column
     */
    column(column: number, layout?: ColumnOptions): GridStack;
    /**
     * get the number of columns in the grid (default 12)
     */
    getColumn(): number;
    /** returns an array of grid HTML elements (no placeholder) - used to iterate through our children in DOM order */
    getGridItems(): GridItemHTMLElement[];
    /**
     * Destroys a grid instance. DO NOT CALL any methods or access any vars after this as it will free up members.
     * @param removeDOM if `false` grid and items HTML elements will not be removed from the DOM (Optional. Default `true`).
     */
    destroy(removeDOM?: boolean): GridStack;
    /**
     * enable/disable floating widgets (default: `false`) See [example](http://gridstackjs.com/demo/float.html)
     */
    float(val: boolean): GridStack;
    /**
     * get the current float mode
     */
    getFloat(): boolean;
    /**
     * Get the position of the cell under a pixel on screen.
     * @param position the position of the pixel to resolve in
     * absolute coordinates, as an object with top and left properties
     * @param useDocRelative if true, value will be based on document position vs parent position (Optional. Default false).
     * Useful when grid is within `position: relative` element
     *
     * Returns an object with properties `x` and `y` i.e. the column and row in the grid.
     */
    getCellFromPixel(position: MousePosition, useDocRelative?: boolean): CellPosition;
    /** returns the current number of rows, which will be at least `minRow` if set */
    getRow(): number;
    /**
     * Checks if specified area is empty.
     * @param x the position x.
     * @param y the position y.
     * @param w the width of to check
     * @param h the height of to check
     */
    isAreaEmpty(x: number, y: number, w: number, h: number): boolean;
    /**
     * If you add elements to your grid by hand, you have to tell gridstack afterwards to make them widgets.
     * If you want gridstack to add the elements for you, use `addWidget()` instead.
     * Makes the given element a widget and returns it.
     * @param els widget or single selector to convert.
     *
     * @example
     * let grid = GridStack.init();
     * grid.el.appendChild('<div id="gsi-1" gs-w="3"></div>');
     * grid.makeWidget('#gsi-1');
     */
    makeWidget(els: GridStackElement): GridItemHTMLElement;
    /**
     * Event handler that extracts our CustomEvent data out automatically for receiving custom
     * notifications (see doc for supported events)
     * @param name of the event (see possible values) or list of names space separated
     * @param callback function called with event and optional second/third param
     * (see README documentation for each signature).
     *
     * @example
     * grid.on('added', function(e, items) { log('added ', items)} );
     * or
     * grid.on('added removed change', function(e, items) { log(e.type, items)} );
     *
     * Note: in some cases it is the same as calling native handler and parsing the event.
     * grid.el.addEventListener('added', function(event) { log('added ', event.detail)} );
     *
     */
    on(name: GridStackEvent, callback: GridStackEventHandlerCallback): GridStack;
    /**
     * unsubscribe from the 'on' event below
     * @param name of the event (see possible values)
     */
    off(name: GridStackEvent): GridStack;
    /**
     * Removes widget from the grid.
     * @param el  widget or selector to modify
     * @param removeDOM if `false` DOM element won't be removed from the tree (Default? true).
     * @param triggerEvent if `false` (quiet mode) element will not be added to removed list and no 'removed' callbacks will be called (Default? true).
     */
    removeWidget(els: GridStackElement, removeDOM?: boolean, triggerEvent?: boolean): GridStack;
    /**
     * Removes all widgets from the grid.
     * @param removeDOM if `false` DOM elements won't be removed from the tree (Default? `true`).
     */
    removeAll(removeDOM?: boolean): GridStack;
    /**
     * Toggle the grid animation state.  Toggles the `grid-stack-animate` class.
     * @param doAnimate if true the grid will animate.
     */
    setAnimation(doAnimate: boolean): GridStack;
    /**
     * Toggle the grid static state, which permanently removes/add Drag&Drop support, unlike disable()/enable() that just turns it off/on.
     * Also toggle the grid-stack-static class.
     * @param val if true the grid become static.
     */
    setStatic(val: boolean): GridStack;
    /**
     * Updates widget position/size and other info. Note: if you need to call this on all nodes, use load() instead which will update what changed.
     * @param els  widget or selector of objects to modify (note: setting the same x,y for multiple items will be indeterministic and likely unwanted)
     * @param opt new widget options (x,y,w,h, etc..). Only those set will be updated.
     */
    update(els: GridStackElement, opt: GridStackWidget): GridStack;
    /**
     * Updates the margins which will set all 4 sides at once - see `GridStackOptions.margin` for format options (CSS string format of 1,2,4 values or single number).
     * @param value margin value
     */
    margin(value: numberOrString): GridStack;
    /** returns current margin number value (undefined if 4 sides don't match) */
    getMargin(): number;
    /**
     * Returns true if the height of the grid will be less than the vertical
     * constraint. Always returns true if grid doesn't have height constraint.
     * @param node contains x,y,w,h,auto-position options
     *
     * @example
     * if (grid.willItFit(newWidget)) {
     *   grid.addWidget(newWidget);
     * } else {
     *   alert('Not enough free space to place the widget');
     * }
     */
    willItFit(node: GridStackWidget): boolean;
    /**
     * called when we are being resized by the window - check if the one Column Mode needs to be turned on/off
     * and remember the prev columns we used, as well as check for auto cell height (square)
     */
    onParentResize(): GridStack;
    /** add or remove the window size event handler */
    private _updateWindowResizeEvent;
    /**
     * call to setup dragging in from the outside (say toolbar), by specifying the class selection and options.
     * Called during GridStack.init() as options, but can also be called directly (last param are cached) in case the toolbar
     * is dynamically create and needs to change later.
     * @param dragIn string selector (ex: '.sidebar .grid-stack-item')
     * @param dragInOptions options - see DDDragInOpt. (default: {revert: 'invalid', handle: '.grid-stack-item-content', scroll: false, appendTo: 'body'}
     **/
    static setupDragIn(dragIn?: string, dragInOptions?: DDDragInOpt): void;
    /**
     * Enables/Disables dragging by the user of specific grid element. If you want all items, and have it affect future items, use enableMove() instead. No-op for static grids.
     * IF you are looking to prevent an item from moving (due to being pushed around by another during collision) use locked property instead.
     * @param els widget or selector to modify.
     * @param val if true widget will be draggable.
     */
    movable(els: GridStackElement, val: boolean): GridStack;
    /**
     * Enables/Disables user resizing of specific grid element. If you want all items, and have it affect future items, use enableResize() instead. No-op for static grids.
     * @param els  widget or selector to modify
     * @param val  if true widget will be resizable.
     */
    resizable(els: GridStackElement, val: boolean): GridStack;
    /**
     * Temporarily disables widgets moving/resizing.
     * If you want a more permanent way (which freezes up resources) use `setStatic(true)` instead.
     * Note: no-op for static grid
     * This is a shortcut for:
     * @example
     *  grid.enableMove(false);
     *  grid.enableResize(false);
     */
    disable(): GridStack;
    /**
     * Re-enables widgets moving/resizing - see disable().
     * Note: no-op for static grid.
     * This is a shortcut for:
     * @example
     *  grid.enableMove(true);
     *  grid.enableResize(true);
     */
    enable(): GridStack;
    /**
     * Enables/disables widget moving. No-op for static grids.
     */
    enableMove(doEnable: boolean): GridStack;
    /**
     * Enables/disables widget resizing. No-op for static grids.
     */
    enableResize(doEnable: boolean): GridStack;
}
