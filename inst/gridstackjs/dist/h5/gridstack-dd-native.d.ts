/**
 * gridstack-dd-native.ts 4.2.3
 * Copyright (c) 2021 Alain Dumesny - see GridStack root license
 */
import { DDElementHost } from './dd-element';
import { GridStackElement } from '../gridstack';
import { GridStackDD, DDOpts, DDKey, DDDropOpt, DDCallback, DDValue } from '../gridstack-dd';
import { GridItemHTMLElement, DDDragInOpt } from '../types';
export * from '../gridstack-dd';
/**
 * HTML 5 Native DragDrop based drag'n'drop plugin.
 */
export declare class GridStackDDNative extends GridStackDD {
    resizable(el: GridItemHTMLElement, opts: DDOpts, key?: DDKey, value?: DDValue): GridStackDDNative;
    draggable(el: GridItemHTMLElement, opts: DDOpts, key?: DDKey, value?: DDValue): GridStackDDNative;
    dragIn(el: GridStackElement, opts: DDDragInOpt): GridStackDDNative;
    droppable(el: GridItemHTMLElement, opts: DDOpts | DDDropOpt, key?: DDKey, value?: DDValue): GridStackDDNative;
    /** true if element is droppable */
    isDroppable(el: DDElementHost): boolean;
    /** true if element is draggable */
    isDraggable(el: DDElementHost): boolean;
    /** true if element is draggable */
    isResizable(el: DDElementHost): boolean;
    on(el: GridItemHTMLElement, name: string, callback: DDCallback): GridStackDDNative;
    off(el: GridItemHTMLElement, name: string): GridStackDD;
}
