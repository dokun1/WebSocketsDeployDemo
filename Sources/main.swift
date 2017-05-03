import Foundation
import Kitura
import KituraWebSocket
import HeliumLogger
import LoggerAPI
import Configuration
import CloudFoundryEnv

let router = Router()
HeliumLogger.use()

let manager = ConfigurationManager().load(.environmentVariables)

#if os(Linux)
srand(UInt32(time(nil)))
#endif

private func generateRandomString(withLength: Int) -> String {
    Log.info("generating random string of length: \(withLength)")
    let charArray: [String] = "abcdefghijklmnopqrstuvwxyz0123456789".characters.map { String($0) }
    var randomString = ""
    for _ in 0 ..< withLength {
        #if os(Linux)
        let rand = Int(random() % charArray.count)
        #else
        let rand = Int(arc4random_uniform(UInt32(charArray.count)))
        #endif
        randomString += charArray[rand]   
    }
    Log.info("Generated random string: \(randomString)")
    return randomString
}

router.get("/register") { request, response, next in
    defer { next() }
    Log.info("register path hit")
    let path = generateRandomString(withLength: 8)
    Log.info("Sending response with path: \(path)")
    WebSocket.register(service: PathService(), onPath: path)
    response.send(json: ["path" : path])   
}

Kitura.addHTTPServer(onPort: manager.port, with: router)

Log.info("API listening on port \(manager.port)")

Kitura.run()
