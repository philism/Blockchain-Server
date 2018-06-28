//
//  BlockchainController.swift
//  App
//
//  Created by Philip Smith on 6/15/18.
//

import Foundation
import Vapor

final class BlockchainController {
  private (set) var blockchainService : BlockchainService
  
  init() {
    self.blockchainService = BlockchainService()
  }
  
  func hello(_ req: Request) throws -> String {
    return "hello blockchain"
  }
  
  func blockchain(_ req: Request) throws -> String {
    let blockchain = self.blockchainService.getBlockchain()
    let data = try! JSONEncoder().encode(blockchain)
    return String(data: data, encoding: .utf8)!
  }
  
  func mine(_ req: Request) throws -> Future<String> {
    return try req.content.decode(Transaction.self).map(to: String.self, {transaction in
      print("To: \(transaction.to)")
      print("From: \(transaction.from)")
      print("Amount: \(transaction.amount)")
      let block = self.blockchainService.getMinedBlock(transactions: [transaction])
      //block.addTransaction(transaction: transaction)
      print("Block is \(block) and transaction is \(transaction)")
      let data = try! JSONEncoder().encode(block)
      return String(data: data, encoding: .utf8)!
    })
  }
  
  func registerNode(_ req: Request) throws -> Future<String> {
    return try req.content.decode(BlockchainNode.self).map(to: String.self, {node in
      print("Address: \(node.address)")
      let blockChainNode = BlockchainNode(address: node.address)
      self.blockchainService.registerNode(node: blockChainNode)
      return String(data: try JSONEncoder().encode(["message":"success"]), encoding: .utf8)!
    })
  }
  
  func listNodes(_ req: Request) throws -> String {
    let nodes = self.blockchainService.blockchain.nodes
    let data = try! JSONEncoder().encode(nodes)
    return String(data: data, encoding: .utf8)!
  }
  
  func resolveNodes(_ req: Request) throws -> Future<String> {
    let promiseString = req.eventLoop.newPromise(String.self)
    self.blockchainService.resolve(completion: { (blockchain) in
      do {
        let data = try JSONEncoder().encode(blockchain)
        let json = String(data:data, encoding: .utf8)!
        promiseString.succeed(result: json)
      } catch let error as NSError {
        promiseString.fail(error: error)
      }
    })
    return promiseString.futureResult
  }
}
