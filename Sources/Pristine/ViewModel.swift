//
//  ViewModel.swift
//  Pristine
//
//  Created by yukonblue on 2024-08-26.
//

import Foundation
import Observation

@Observable
@MainActor
public final class ViewModel<F: Feature> {

    // TODO: Look into making this internal at least
    public var state: F.State

    @ObservationIgnored
    private let feature: F

    @ObservationIgnored
    private let actionsStream: AsyncStream<F.Action>
    @ObservationIgnored
    private let actionsContinuation: AsyncStream<F.Action>.Continuation

    @ObservationIgnored
    public let signalsStream: AsyncStream<F.Signal>
    @ObservationIgnored
    private let signalsContinuation: AsyncStream<F.Signal>.Continuation

    @ObservationIgnored
    private let sink: SinkImpl

    public init(feature: F) {
        self.feature = feature
        self.state = feature.makeInitialState()

        (self.actionsStream, self.actionsContinuation) = AsyncStream<F.Action>.makeStream()
        (self.signalsStream, self.signalsContinuation) = AsyncStream<F.Signal>.makeStream()

        self.sink = .init(actionsContinuation: actionsContinuation, signalsContinuation: signalsContinuation)
    }

    public func setUp() {
        Task { @MainActor in
            for await action in self.actionsStream {
                self.feature.reduce(
                    state: &self.state,
                    action: action,
                    sink: self.sink
                )
            }
        }
    }

    public func tearDown() {
        self.actionsContinuation.finish()
        self.signalsContinuation.finish()
    }

    private struct SinkImpl: Sink {
        let actionsContinuation: AsyncStream<F.Action>.Continuation
        let signalsContinuation: AsyncStream<F.Signal>.Continuation

        typealias Action = F.Action

        func send(action: F.Action) {
            actionsContinuation.yield(action)
        }

        func signal(_ signal: F.Signal) {
            signalsContinuation.yield(signal)
        }

        func run(_ fn: @escaping (_ : Self) async -> Void) {
            Task { @MainActor in
                await fn(self)
            }
        }
    }

    public func action(_ action: F.Action) {
        actionsContinuation.yield(action)
    }
}
