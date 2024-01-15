//
//  TransmissionData.swift
//
//
//  Created by Dr. Brandon Wiley on 1/15/24.
//

import Foundation

import Straw
import Transmission

public class TransmissionData: Transmission.Connection
{
    var readBuffer: UnsafeStraw = UnsafeStraw()
    var writeBuffer: UnsafeStraw = UnsafeStraw()
    var closed: Bool = false

    let readLock: DispatchSemaphore = DispatchSemaphore(value: 1)
    let writeLock: DispatchSemaphore = DispatchSemaphore(value: 1)

    public init(readBuffer: Data = Data(), writeBuffer: Data = Data())
    {
        self.readBuffer.write(readBuffer)
        self.writeBuffer.write(writeBuffer)
    }

    // Transmission.Connection
    public func read(size: Int) -> Data?
    {
        defer
        {
            self.readLock.signal()
        }
        self.readLock.wait()

        if closed
        {
            return nil
        }

        return try? self.readBuffer.read(size: size)
    }

    public func unsafeRead(size: Int) -> Data?
    {
        if closed
        {
            return nil
        }

        return try? self.readBuffer.read(size: size)
    }

    public func read(maxSize: Int) -> Data?
    {
        defer
        {
            self.readLock.signal()
        }
        self.readLock.wait()

        if closed
        {
            return nil
        }

        return try? self.readBuffer.read(maxSize: maxSize)
    }

    public func readWithLengthPrefix(prefixSizeInBits: Int) -> Data?
    {
        if closed
        {
            return nil
        }

        return Transmission.readWithLengthPrefix(prefixSizeInBits: prefixSizeInBits, connection: self)
    }

    public func write(string: String) -> Bool
    {
        defer
        {
            self.writeLock.signal()
        }
        self.writeLock.wait()

        if closed
        {
            return false
        }

        self.writeBuffer.write(string.data)

        return true
    }

    public func write(data: Data) -> Bool
    {
        defer
        {
            self.writeLock.signal()
        }
        self.writeLock.wait()

        if closed
        {
            return false
        }

        self.writeBuffer.write(data)

        return true
    }

    public func writeWithLengthPrefix(data: Data, prefixSizeInBits: Int) -> Bool
    {
        if closed
        {
            return false
        }

        return Transmission.writeWithLengthPrefix(data: data, prefixSizeInBits: prefixSizeInBits, connection: self)
    }

    public func close()
    {
        self.closed = true
    }
    // End Transmission.Connection

    public func flip()
    {
        self.readBuffer = self.writeBuffer
        self.writeBuffer = UnsafeStraw()
    }
}
