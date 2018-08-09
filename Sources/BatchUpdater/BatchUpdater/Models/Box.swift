import Foundation

struct Box: DeepHashable {
    var value: DeepHashable

    // MARK: - DeepHashable
    var deepDiffHash: Int {
        return value.deepDiffHash
    }

    func equal(object: Any?) -> Bool {
        if let object = object as? Box {
            return self.value.equal(object: object.value)
        } else if let object = object as? DeepHashable {
            return self.value.equal(object: object)
        }

        return false
    }
}
