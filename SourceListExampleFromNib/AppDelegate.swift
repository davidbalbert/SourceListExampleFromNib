//
//  AppDelegate.swift
//  SourceListExampleFromNib
//
//  Created by David Albert on 11/10/20.
//

import Cocoa

struct Item: Equatable, Hashable {
    var text: String
    var children: [Item]?
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSOutlineViewDelegate, NSOutlineViewDataSource {
    @IBOutlet var window: NSWindow!
    @IBOutlet var outlineView: NSOutlineView!
    
    var data = [
        Item(text: "Foo"),
        Item(text: "Bar"),
        Item(text: "Hello", children: [
            Item(text: "Baz"),
            Item(text: "Qux"),
        ]),
        Item(text: "World", children: [
            Item(text: "Quux"),
            Item(text: "Quuux"),
        ])
    ]

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        outlineView.expandItem(nil, expandChildren: true)
        
        window.center()
        window.makeKeyAndOrderFront(self)
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        if let item = item as? Item, let children = item.children {
            return children[index]
        } else {
            return data[index]
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        if let item = item as? Item {
            return item.children?.count ?? 0
        } else {
            return data.count
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        if let item = item as? Item {
            return item.children != nil
        } else {
            return false
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, isGroupItem item: Any) -> Bool {
        if let item = item as? Item {
            return isGroup(item)
        } else {
            return false
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, shouldSelectItem item: Any) -> Bool {
        if let item = item as? Item {
            return !isGroup(item)
        } else {
            return true
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        guard let item = item as? Item else {
            return nil
        }

        guard let view = outlineView.makeView(withIdentifier: .init("Main"), owner: self) as? NSTableCellView else {
            return nil
        }

        view.textField?.stringValue = item.text

        return view
    }

    func isGroup(_ item: Item) -> Bool {
        item.children != nil && data.contains(item)
    }
}

