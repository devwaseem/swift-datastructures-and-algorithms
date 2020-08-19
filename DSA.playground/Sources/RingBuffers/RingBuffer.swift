
public struct RingBuffer<T> {
    
    private var storage: [T?]
    private var writeIndex = 0
    private var readIndex = 0
    
    var first:T? {
        return storage[readIndex % storage.count]
    }
    
    var isEmpty:Bool {
        return availableSpaceForReading == 0
    }
    
    var isFull: Bool {
        return availableSpaceForWriting == 0
    }
    
    private var availableSpaceForReading: Int {
        return writeIndex - readIndex
    }
    
    private var availableSpaceForWriting: Int {
        return storage.count - availableSpaceForReading
    }
    
    public init(count: Int) {
        storage = [T?](repeating: nil, count: count)
    }
    
    mutating public func write(_ element:T) -> Bool {
        if isFull {
           return false
        }
        storage[writeIndex % storage.count] = element
        writeIndex += 1
        return true
    }
    
    mutating public func read() -> T? {
        if isEmpty {
            return nil
        }
        let element = storage[readIndex % storage.count]
        readIndex += 1
        return element
    }
    
}

extension RingBuffer: CustomStringConvertible {
    public var description: String {
        return storage.description
    }
}

extension RingBuffer: Sequence {
    public func makeIterator() -> AnyIterator<T> {
        var index = readIndex
        return AnyIterator {
            guard index < self.writeIndex else { return nil }
            defer {
                index += 1
            }
            return self.storage[index % self.storage.count]
        }
    }
}
