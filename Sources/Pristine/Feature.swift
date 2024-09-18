//
//  Feature.swift
//  Pristine
//
//  Created by yukonblue on 2024-08-26.
//

public protocol Feature {

    associatedtype State

    associatedtype Action

    associatedtype Signal

    func makeInitialState() -> State

    func reduce<S: Sink>(state: inout State, action: Action, sink: S) where S.Action == Action, S.Signal == Signal
}
