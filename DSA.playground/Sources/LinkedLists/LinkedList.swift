
public struct LinkedList<Type> {
    public var head: Node<Type>?
    public var tail: Node<Type>?
    public init() {}
    public var isEmpty: Bool {
        return head == nil
    }
    
    public func node(at index:Int) -> Node<Type>? {
        var currentNode = head
        var currentIndex = 0
        
        while currentNode != nil && currentIndex < index {
            currentNode = currentNode!.next
            currentIndex += 1
        }
        
        return currentNode
    }
    
    //MARK:- Addition operations
    public mutating func push(_ value: Type){
        copyNodes()
        head = Node(value:value,next:head)
        if tail == nil {
            tail = head
        }
    }
    
    public mutating func append(_ value: Type){
        copyNodes()
        guard !isEmpty else {
            push(value)
            return
        }
        tail!.next = Node(value:value)
        tail = tail!.next
    }
    
    @discardableResult
    public mutating func insert(_ value: Type,after node:Node<Type>) -> Node<Type> {
        copyNodes()
        guard tail !== node else {
            append(value)
            return tail!
        }
        
        node.next = Node(value: value, next: node.next)
        return node.next!
    }
    
    //MARK:- Removing operations
    
    @discardableResult
    public mutating func pop() -> Type? {
        copyNodes()
        defer {
            head = head?.next
            if isEmpty {
                tail = nil
            }
        }
        
        return head?.value
    }
    
    @discardableResult
    public mutating func removeLast() -> Type? {
        copyNodes()
        guard let head = head else {
            return nil
        }
        
        guard head.next != nil else {
            return pop()
        }
        
        var prev = head
        var current = head
        
        while let next = current.next {
            prev = current
            current = next
        }
        
        prev.next = nil
        tail = prev
        return current.value
    }
    
    @discardableResult
    public mutating func remove(after node:Node<Type>) -> Type? {
        copyNodes()
        
        defer {
            if node.next === tail {
                tail = node
            }
            node.next = node.next?.next
        }
        
        return node.next?.value
    }
    
    public mutating func reverse(){
        copyNodes()
        var prev:Node<Type>? = nil
        var current = head
        while current != nil {
            let next = current?.next
            current?.next = prev
            prev = current
            current = next
        }
        head = prev
    }
    
    
    //MARK:- Copy On Write
    private mutating func copyNodes(){
        guard !isKnownUniquelyReferenced(&head) else {
            return
        }
        
        guard var oldNode = head else {
            return
        }
        
        head = Node(value: oldNode.value)
        var newNode = head
        while let nextOldNode = oldNode.next {
            newNode!.next = Node(value: nextOldNode.value)
            newNode = newNode!.next
            oldNode = nextOldNode
        }
        tail = newNode
    }
}

extension LinkedList {
    public class Node<Type> {
        
        public var value:Type
        public var next:Node?
        
        public init(value:Type,next:Node? = nil){
            self.value = value
            self.next = next
        }
    }
}

extension LinkedList.Node: CustomStringConvertible {
       
       public var description: String {
           guard let next = next else {
               return "\(value)"
           }
           return "\(value) -> " + String(describing: next) + " "
       }
   }

extension LinkedList: CustomStringConvertible {
    public var description: String {
        guard let head = head else {
            return "Empty list"
        }
        return String(describing: head)
    }
}

extension LinkedList: Collection {
    
    
    public var startIndex: Index {
        return Index(node:head)
    }
    
    public var endIndex: Index {
        return Index(node: tail?.next)
    }
    
    public func index(after i: Index) -> Index {
        return Index(node: i.node?.next)
    }

    public subscript(position: Index) -> Type {
        return position.node!.value
    }
    
    
    public struct Index: Comparable {
 
        public var node: Node<Type>?
        
        static public func ==(lhs:Index,rhs:Index) -> Bool {
            switch (lhs.node,rhs.node) {
            case let (left?, right?):
                return left.next === right.next
            case (nil,nil):
                return true
            default:
                return false
            }
        }
        
        public static func < (lhs: Index, rhs: Index) -> Bool {
            guard lhs != rhs else {
                return false
            }
            
            let nodes = sequence(first: lhs.node) { $0?.next }
            return nodes.contains { $0 === rhs.node }
        }
    }
    
    
}
