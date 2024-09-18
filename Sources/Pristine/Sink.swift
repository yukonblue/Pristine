//
//  Sink.swift
//  Pristine
//
//  Created by yukonblue on 2024-08-26.
//

public protocol Sink {

    associatedtype Action

    associatedtype Signal

    func send(action: Action)

    func signal(_: Signal)

    func run(_ fn: @escaping (_: Self) async -> Void)
}
