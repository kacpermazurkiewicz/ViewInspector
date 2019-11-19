import SwiftUI

public extension ViewType {
    
    struct ForEach: KnownViewType {
        public static var typePrefix: String { "ForEach" }
    }
}

public extension ForEach {
    
    func inspect() throws -> InspectableView<ViewType.ForEach> {
        return try InspectableView<ViewType.ForEach>(self)
    }
}

// MARK: - MultipleViewContent

extension ViewType.ForEach: MultipleViewContent {
    
    public static func content(view: Any) throws -> [Any] {
        guard let children = try (view as? ForEachContentProvider)?.content() else {
            throw InspectionError.typeMismatch(view, ForEachContentProvider.self)
        }
        return children
    }
}

// MARK: - SingleViewContent

public extension InspectableView where View: SingleViewContent {
    
    func forEach() throws -> InspectableView<ViewType.ForEach> {
            
        let content = try View.content(view: view)
        return try InspectableView<ViewType.ForEach>(content)
    }
}

// MARK: - MultipleViewContent

public extension InspectableView where View: MultipleViewContent {
    
    func forEach(_ index: Int) throws -> InspectableView<ViewType.ForEach> {
            
        let content = try contentView(at: index)
        return try InspectableView<ViewType.ForEach>(content)
    }
}

// MARK: - Private

private protocol ForEachContentProvider {
    func content() throws -> [Any]
}

extension ForEach: ForEachContentProvider {
    func content() throws -> [Any] {
        let data = try Inspector.attribute(label: "data", value: self)
        let content = try Inspector.attribute(label: "content", value: self)
        typealias Elements = [Data.Element]
        guard let dataArray = data as? Elements
            else { throw InspectionError.typeMismatch(data, Elements.self) }
        typealias Builder = (Data.Element) -> Content
        guard let builder = content as? Builder
            else { throw InspectionError.typeMismatch(content, Builder.self) }
        return dataArray.map { builder($0) } as [Any]
    }
}