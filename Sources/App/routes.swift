import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
  
/*
    router.get("hello") { req in
        return "Hello, world!"
    }

    // Example of configuring a controller

   let todoController = TodoController()
   router.get("todos", use: todoController.index)
   router.post("todos", use: todoController.create)
   router.delete("todos", Todo.parameter, use: todoController.delete)
*/
  
  
  let blockchainController = BlockchainController()
  router.get("hello", use: blockchainController.hello)
  router.get("blockchain", use: blockchainController.blockchain)
  router.post("mine", use: blockchainController.mine)
  router.post("nodes/register", use: blockchainController.registerNode)
  router.get("nodes", use: blockchainController.listNodes)
  router.get("nodes/resolve", use: blockchainController.resolveNodes)
}
