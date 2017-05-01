import Foundation
import Kitura
import KituraWebSocket
import HeliumLogger
import LoggerAPI

let router = Router()
HeliumLogger.use()

#if os(Linux)
srand(UInt32(time(nil)))
#endif

private func generateRandomString(withLength: Int) -> String {
    Log.info("generating random string")
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
    
    return randomString
}

router.get("/register") { request, response, next in
    defer { next() }
    Log.info("register path hit")
    Log.info("sending path")
    let path = generateRandomString(withLength: 8)
    WebSocket.register(service: PathService(), onPath: path)
    response.send(json: ["path" : path])   
}

let envVars = ProcessInfo.processInfo.environment
let portString = envVars["PORT"] ?? envVars["CF_INSTANCE_PORT"] ?? envVars["VCAP_APP_PORT"] ?? "8090"
let port = Int(portString) ?? 8090
Kitura.addHTTPServer(onPort: port, with: router)
Log.info("API listening on port \(port)")
Kitura.run()
