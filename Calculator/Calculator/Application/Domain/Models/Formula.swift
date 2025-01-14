//
//  Formula.swift
//  Calculator
//
//  Created by Gordon Choi on 2022/05/19.
//

struct Formula {
    let operands: CalculatorItemQueue<Double>
    let operators: CalculatorItemQueue<Operator>
    
    func result() throws -> Double {
        var operands = self.operands
        var operators = self.operators
        
        guard var result = operands.dequeue() else {
            throw CalculatorError.noRemainingValue
        }
        
        while let nextOperator = operators.dequeue(),
              let nextOperand = operands.dequeue() {
            do {
                let newValue = try nextOperator.calculate(lhs: result, rhs: nextOperand)
                result = newValue
            } catch CalculatorError.dividedByZero {
                throw CalculatorError.dividedByZero
            }
        }
        
        return result
    }
}
