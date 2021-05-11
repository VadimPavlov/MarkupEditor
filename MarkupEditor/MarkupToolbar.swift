//
//  MarkupToolbar.swift
//  MarkupEditor
//
//  Created by Steven Harris on 2/28/21.
//  Copyright © 2021 Steven Harris. All rights reserved.
//

import SwiftUI

/// The MarkupToolbar acts on the selectedWebView and shows the current selectionState.
///
/// The MarkupToolbar observes the selectionState so that its display reflects the current state.
/// For example, when selectedWebView is nil, the toolbar is disabled, and when the selectionState shows
/// that the selection is inside of a bolded element, then the bold (B) button is active and filled-in.
public struct MarkupToolbar: View {
    
    public enum ToolbarType: CaseIterable {
        case image
        case link
        case table
    }
    
    @Binding public var selectedWebView: MarkupWKWebView?
    @ObservedObject private var selectionState: SelectionState
    private var markupDelegate: MarkupDelegate?
    @State private var showLinkToolbar: Bool = false
    @State private var showImageToolbar: Bool = false
    @State private var showTableToolbar: Bool = false
    /// User-supplied view to be shown on the left side of the default MarkupToolbar
    private var leftToolbar: AnyView?
    /// User-supplied view to be shown on the right side of the default MarkupToolbar
    private var rightToolbar: AnyView?
    
    public var body: some View {
        VStack(spacing: 2) {
            HStack(alignment: .bottom) {
                if leftToolbar != nil {
                    leftToolbar
                    Divider()
                }
                Group {
                    UndoRedoToolbar(selectionState: selectionState, selectedWebView: $selectedWebView)
                    Divider()
                    InsertToolbar(selectionState: selectionState, selectedWebView: $selectedWebView, showLinkToolbar: $showLinkToolbar, showImageToolbar: $showImageToolbar, showTableToolbar: $showTableToolbar)
                    Divider()
                    StyleToolbar(selectionState: selectionState, selectedWebView: $selectedWebView)
                    Divider()
                    FormatToolbar(selectionState: selectionState, selectedWebView: $selectedWebView)
                    Divider()           // Vertical on the right
                }
                if rightToolbar != nil {
                    rightToolbar
                    Divider()
                }
                Spacer()            // Push everything to the left
            }
            .frame(height: 47)
            .padding([.leading, .trailing], 8)
            .padding([.top, .bottom], 2)
            .disabled(selectedWebView == nil)
            Divider()           // Horizontal at the bottom
            LinkToolbar(selectionState: selectionState, selectedWebView: $selectedWebView, showToolbar: $showLinkToolbar)
                .isHidden(!showLinkToolbar, remove: !showLinkToolbar)
                .onAppear(perform: {
                    markupDelegate?.markupToolbarAppeared(type: .link)
                })
                .onDisappear(perform: {
                    markupDelegate?.markupToolbarDisappeared()
                    selectedWebView?.becomeFirstResponder()
                })
            ImageToolbar(selectionState: selectionState, selectedWebView: $selectedWebView, showToolbar: $showImageToolbar)
                    .isHidden(!showImageToolbar, remove: !showImageToolbar)
                .onAppear(perform: {
                    markupDelegate?.markupToolbarAppeared(type: .image)
                })
                .onDisappear(perform: {
                    markupDelegate?.markupToolbarDisappeared()
                    selectedWebView?.becomeFirstResponder()
                })
            TableToolbar(selectionState: selectionState, selectedWebView: $selectedWebView, showToolbar: $showTableToolbar)
                .isHidden(!showTableToolbar, remove: !showTableToolbar)
                .onAppear(perform: {
                    markupDelegate?.markupToolbarAppeared(type: .table)
                })
                .onDisappear(perform: {
                    markupDelegate?.markupToolbarDisappeared()
                    selectedWebView?.becomeFirstResponder()
                })
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .background(Color(UIColor.systemBackground))
    }
    
    public init(selectionState: SelectionState, selectedWebView: Binding<MarkupWKWebView?>, markupDelegate: MarkupDelegate? = nil, leftToolbar: AnyView? = nil, rightToolbar: AnyView? = nil) {
        self.selectionState = selectionState
        _selectedWebView = selectedWebView
        self.markupDelegate = markupDelegate
        self.leftToolbar = leftToolbar
        self.rightToolbar = rightToolbar
    }
    
}

//MARK:- Previews

struct MarkupToolbar_Previews: PreviewProvider {
    
    static var previews: some View {
        MarkupToolbar(selectionState: SelectionState(), selectedWebView: .constant(nil))
    }
}


