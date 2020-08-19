public struct QueueArray<Element>:Queue {
    

    private var array: [Element] = []
    public init() {}
    
    public var isEmpty: Bool {
        return array.isEmpty
    }
    
    public var peek: Element? {
        return array.first
    }
    
    public mutating func enqueue(_ element: Element) -> Bool {
        array.append(element)
        return true
    }
    
    public mutating func dequeue() -> Element? {
        return isEmpty ? nil : array.removeFirst()
    }
    
}

extension QueueArray: CustomStringConvertible {
    public var description: String {
        return array.description
    }
}
