public struct QueueStack<Element>: Queue {
    
    private var leftStack: [Element] = []
    private var rightStack: [Element] = []
    
    public var isEmpty: Bool {
        return leftStack.isEmpty && rightStack.isEmpty
    }
    
    public var peek: Element? {
        return !leftStack.isEmpty ? leftStack.last : rightStack.first
    }

    
    public init() {}
    
    @discardableResult
    public mutating func enqueue(_ element: Element) -> Bool {
        rightStack.append(element)
        return true
    }
    
    public mutating func dequeue() -> Element? {
        if leftStack.isEmpty {
            leftStack = rightStack.reversed()
            rightStack.removeAll()
        }
        
        return leftStack.popLast()
    }
}

extension QueueStack: CustomStringConvertible {
    public var description: String {
        let printList = leftStack + rightStack.reversed()
        return printList.description
    }
}
