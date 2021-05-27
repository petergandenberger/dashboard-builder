/**
 * dd-resizable.ts 4.2.3
 * Copyright (c) 2021 Alain Dumesny - see GridStack root license
 */
import { DDBaseImplement, HTMLElementExtendOpt } from './dd-base-impl';
import { DDUIData } from '../types';
export interface DDResizableOpt {
    autoHide?: boolean;
    handles?: string;
    maxHeight?: number;
    maxWidth?: number;
    minHeight?: number;
    minWidth?: number;
    basePosition?: 'fixed' | 'absolute';
    start?: (event: Event, ui: DDUIData) => void;
    stop?: (event: Event) => void;
    resize?: (event: Event, ui: DDUIData) => void;
}
export declare class DDResizable extends DDBaseImplement implements HTMLElementExtendOpt<DDResizableOpt> {
    el: HTMLElement;
    option: DDResizableOpt;
    constructor(el: HTMLElement, opts?: DDResizableOpt);
    on(event: 'resizestart' | 'resize' | 'resizestop', callback: (event: DragEvent) => void): void;
    off(event: 'resizestart' | 'resize' | 'resizestop'): void;
    enable(): void;
    disable(): void;
    destroy(): void;
    updateOption(opts: DDResizableOpt): DDResizable;
}
