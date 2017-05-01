import KituraWebSocket
import LoggerAPI
import Foundation

class PathService: WebSocketService {
    var messageCounter = 0 

    public func connected(connection: WebSocketConnection) {
        Log.info("Connection Established: \(connection)")
    }

    public func disconnected(connection: WebSocketConnection, reason: WebSocketCloseReasonCode) {
        Log.info("Connection closed: Reason: \(reason)")
    }

    public func received(message: Data, from: WebSocketConnection) {
    
    }
 
    public func received(message: String, from: WebSocketConnection) {
        messageCounter += 1
        from.send(message: "You've sent the following message to WebSocket id #\(from.id): \"\(message)\", and this is message #\(messageCounter) for this webSocket.")
    }
}
