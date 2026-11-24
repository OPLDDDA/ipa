import UIKit

enum WallpaperRenderer {
    private static let grainImage: UIImage = {
        let side = 128
        let space = CGColorSpaceCreateDeviceRGB()
        guard let ctx = CGContext(data: nil,
                                  width: side,
                                  height: side,
                                  bitsPerComponent: 8,
                                  bytesPerRow: side * 4,
                                  space: space,
                                  bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue),
              let data = ctx.data else {
            return UIImage()
        }

        let bytes = data.assumingMemoryBound(to: UInt8.self)
        var seed: UInt64 = 0x2545F4914F6CDD1D
        for i in 0..<(side * side) {
            seed = seed &* 6_364_136_223_846_793_005 &+ 1_442_695_040_888_963_407
            let value = UInt8((seed >> 33) & 0xFF)
            bytes[i * 4 + 0] = value
            bytes[i * 4 + 1] = value
            bytes[i * 4 + 2] = value
            bytes[i * 4 + 3] = 255
        }
        guard let image = ctx.makeImage() else { return UIImage() }
        return UIImage(cgImage: image)
    }()

    static func render(preset: WallpaperPreset,
                       settings: RenderSettings,
                       time: TimeInterval,
                       motion: CGPoint,
                       in context: CGContext,
                       size: CGSize) {
        let width = size.width
        let height = size.height
        let minSide = min(width, height)

        context.setFillColor(preset.background.cgColor)
        context.fill(CGRect(x: 0, y: 0, width: width, height: height))

        let motionAmount = CGFloat(max(0, settings.motion))
        let softness = CGFloat(max(0, settings.softness))
        let glow = CGFloat(max(0, min(settings.glow, 2)))

        for (index, blob) in preset.blobs.enumerated() {
            let phase = time * blob.speed * settings.speed + Double(index) * 1.7
            let driftX = CGFloat(cos(phase)) * 0.055 * width * motionAmount
            let driftY = CGFloat(sin(phase * 0.83)) * 0.055 * height * motionAmount
            let centerX = blob.x * width + driftX + motion.x * 70 * motionAmount
            let centerY = blob.y * height + driftY + motion.y * 70 * motionAmount
            let pulse = 1 + 0.06 * CGFloat(sin(phase * 1.3))
            let radius = max(1, blob.radius * minSide * pulse * (1 + softness * 0.30))
            let peak = min(1, 0.88 * glow / (1 + softness * 0.40))

            let colors = [
                blob.color.withAlphaComponent(peak).cgColor,
                blob.color.withAlphaComponent(0).cgColor
            ]
            guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                            colors: colors as CFArray,
                                            locations: [0, 1]) else { continue }

            context.drawRadialGradient(gradient,
                                       startCenter: CGPoint(x: centerX, y: centerY),
                                       startRadius: 0,
                                       endCenter: CGPoint(x: centerX, y: centerY),
                                       endRadius: radius,
                                       options: [])
        }

        let grain = CGFloat(max(0, min(settings.grain, 0.5)))
        guard grain > 0, let tile = grainImage.cgImage else { return }

        let tileSize = CGSize(width: tile.width, height: tile.height)
        context.saveGState()
        context.setAlpha(grain)
        for y in stride(from: 0, to: height, by: tileSize.height) {
            for x in stride(from: 0, to: width, by: tileSize.width) {
                context.draw(tile, in: CGRect(x: x, y: y,
                                              width: tileSize.width,
                                              height: tileSize.height))
            }
        }
        context.restoreGState()
    }
}
