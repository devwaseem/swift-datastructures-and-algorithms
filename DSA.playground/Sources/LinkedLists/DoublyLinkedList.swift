
public struct DoublyLinkedList<Type> {
    
    public var head: Node<Type>?
    public var tail: Node<Type>?
    
    public init(){}
    public var isEmpty: Bool {
        return head == nil
    }
    
    public func node(at index:Int) -> Node<Type>?{
           var currentIndex = 0
           var currentNode = head
           
           while currentNode != nil && currentIndex != index {
               currentIndex += 1
               currentNode = currentNode!.next
           }
           
           return currentNode
    }
    
    public mutating func push(_ value:Type){
       copyNodes()
        let newNode = Node(value: value, next: head)
        head?.prev = newNode
        head = newNode
        if tail == nil {
            tail = head
        }
    }
    
    public mutating func append(_ value:Type){
        copyNodes()
        if isEmpty || tail == nil {
            push(value)
            return
        }
        
        tail?.next = Node(value: value,prev: tail)
        tail = tail?.next
    }
    

    @discardableResult
    public mutating func insert(value: Type, after node:Node<Type>) -> Node<Type>?  {
        copyNodes()
        guard tail !== node else {
            append(value)
            return tail!
        }
        
        node.next = Node(value: value, prev: node, next: node.next)
        return node.next
    }
    
    @discardableResult
    public mutating func pop() -> Type? {
        copyNodes()
        defer {
            head = head?.next
            head?.prev = nil
            if isEmpty {
                tail = nil
            }
        }
        
        return head?.value
    }
    
    @discardableResult
    public mutating func removeLast() -> Type? {
        copyNodes()
        defer {
            tail = tail?.prev
            tail?.next = nil
        }
        
        return tail?.value
    }
    
    @discardableResult
    public mutating func remove(after node:Node<Type>) -> Type? {
        copyNodes()
        guard tail !== node else {
            return removeLast()
        }
    
        node.next = node.next?.next
        return node.next?.value
    }
    
    public mutating func reverse(){
        copyNodes()
        var current = head
        var temp:Node<Type>? = nil
        
        while current != nil {
            temp = current?.prev
            current?.prev = current?.next
            current?.next = temp
            current = current?.prev
        }
        if let temp = temp {
            head = temp.prev
        }
        
    }
    
    private mutating func copyNodes(){
        guard isKnownUniquelyReferenced(&head) else {
            return
        }
       
        guard var oldNode = head else {
            return
        }
        
        print("copying")
        var newNode = Node(value: oldNode.value)
        head = newNode
        while let nextOldnode = oldNode.next {
            newNode.next = Node(value:nextOldnode.value,prev:newNode)
            newNode = newNode.next!
            oldNode = nextOldnode
        }
        tail = newNode
    }
}


extension DoublyLinkedList {
    
    public class Node<Type> {
        
        public var prev: Node<Type>?
        public var value: Type
        public var next: Node<Type>?
        
        public init(value:Type, prev: Node<Type>? = nil, next: Node<Type>? = nil) {
            self.value = value
            self.prev = prev
            self.next = next
        }
    }
    
}

extension DoublyLinkedList.Node: CustomStringConvertible {
    
    public var description: String {
        guard let next = next else {
            return "\(value)"
        }
        return "\(value) <-> "  + String(describing:next) + " "
    }
    
}

extension DoublyLinkedList: CustomStringConvertible {
    public var description: String {
        guard let head = head else {
            return "Empty list"
        }
        return String(describing: head)
    }
}

extension DoublyLinkedList: Collection {
    
    public var startIndex: Index {
        return Index(node: head)
    }
    
    public var endIndex: Index {
        return Index(node: tail?.next)
    }
    
    public func index(after i:Index) -> Index {
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
        
        public static func < (lhs: DoublyLinkedList<Type>.Index, rhs: DoublyLinkedList<Type>.Index) -> Bool {
            guard lhs != rhs else {
                return false
            }
            
            let nodes = sequence(first: lhs.node) { $0?.next }
            return nodes.contains { $0 === rhs.node }
        }
    }
}


