import Foundation
import CoreBluetooth
import McuManager

@objcMembers
public class FirmwareUpgradeManagerWrapper: NSObject {

    public var completionHandler: ((Any?) -> ())? = nil

    private let peripheral: CBPeripheral
    private let firmware: Data?
    private var dfuManager: FirmwareUpgradeManager?

    public init(peripheral: CBPeripheral, firmware: Data?) {
        self.peripheral = peripheral
        self.firmware = firmware
    }

    public func configure() {
        guard let bleTransport = McuMgrBleTransport(peripheral) else { return }
        dfuManager = FirmwareUpgradeManager(transporter: bleTransport, delegate: nil)
        dfuManager?.estimatedSwapTime = 10.0 // nRF52840 requires ~ 10 seconds for swapping images, needs adjustment
        dfuManager?.mode = .testAndConfirm
    }

    public func startUpdate() {
        print("LLL, starting updating the firmware")
        do {
            var bytes = [137, 80, 78, 71, 13, 10, 26, 10, 0, 0, 0, 13, 73, 72, 68, 82, 0, 0, 0, 130, 0, 0, 0, 22, 8, 6, 0, 0, 0, 12, 244, 68, 168, 0, 0, 0, 1, 115, 82, 71, 66, 0, 174, 206, 28, 233, 0, 0, 0, 4, 103, 65, 77, 65, 0, 0, 177, 143, 11, 252, 97, 5, 0, 0, 0, 9, 112, 72, 89, 115, 0, 0, 14, 196, 0, 0, 14, 196, 1, 149, 43, 14, 27, 0, 0, 3, 212, 73, 68, 65, 84, 104, 67, 237, 153, 61, 139, 20, 65, 16, 134, 55, 17, 253, 3, 114, 127, 224, 208, 204, 64, 228, 18, 3, 19, 21, 19, 35, 217, 200, 204, 15, 48, 19, 228, 48, 50, 242, 76, 12, 245, 2, 99, 47, 55, 88, 83, 65, 220, 76, 48, 57, 19, 49, 220, 95, 224, 125, 120, 34, 126, 224, 120, 207, 65, 141, 53, 189, 213, 85, 189, 238, 172, 176, 210, 5, 195, 206, 77, 87, 87, 247, 84, 189, 245, 118, 213, 220, 160, 169, 82, 61, 112, 232, 129, 65, 245, 66, 245, 0, 30, 168, 64, 168, 56, 56, 242, 64, 5, 66, 5, 66, 5, 66, 197, 192, 31, 15, 12, 142, 29, 63, 209, 228, 174, 209, 232, 101, 199, 87, 147, 201, 36, 171, 139, 141, 55, 227, 113, 179, 122, 234, 180, 171, 115, 110, 109, 173, 217, 217, 217, 53, 99, 112, 241, 210, 229, 169, 185, 216, 244, 246, 88, 50, 134, 93, 145, 18, 125, 79, 231, 230, 173, 219, 217, 253, 47, 51, 176, 92, 32, 156, 92, 89, 233, 188, 219, 189, 245, 245, 16, 8, 219, 219, 239];

            let nsData: NSData = NSData(bytes: bytes, length: bytes.count);
            let imageData = Data(referencing: nsData)
            try dfuManager?.start(data: imageData)
        } catch {
            print("LLL, Error reading hash: \(error)")
        }
    }
}

extension FirmwareUpgradeManagerWrapper: FirmwareUpgradeDelegate {
    public func upgradeDidStart(controller: FirmwareUpgradeController) { }

    public func upgradeStateDidChange(from previousState: FirmwareUpgradeState, to newState: FirmwareUpgradeState) { }

    public func upgradeDidComplete() {
        completionHandler?("LLL, Upgrade completed")
    }

    public func upgradeDidFail(inState state: FirmwareUpgradeState, with error: Error) { }

    public func upgradeDidCancel(state: FirmwareUpgradeState) {  }

    public func uploadProgressDidChange(bytesSent: Int, imageSize: Int, timestamp: Date) {
        completionHandler?((bytesSent / imageSize) * 100)
    }
}
