public class QueueLinkedList<T>: Queue {
   
    private var list = DoublyLinkedList<T>()
    public init() {}

    public var isEmpty: Bool {
        return list.isEmpty
    }
    
    public var peek: T? {
        return list.first
    }
    
    public func enqueue(_ element: T) -> Bool {
        list.append(element)
        return true
    }
       
    public func dequeue() -> T? {
        guard !list.isEmpty else {
            return nil
        }
        
        return list.pop()
    }
}

extension QueueLinkedList: CustomStringConvertible {
    public var description: String {
        return list.description
    }
}
