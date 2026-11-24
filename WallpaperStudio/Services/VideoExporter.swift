import AVFoundation
import CoreVideo
import UIKit

enum ExportError: Error {
    case writerFailed
    case inputRejected
    case inputUnavailable
    case pixelBufferFailed
    case appendFailed
}

final class VideoExporter {
    func export(preset: WallpaperPreset,
                settings: RenderSettings,
                duration: Double = 8,
                fps: Int32 = 30,
                size: CGSize = CGSize(width: 1080, height: 1920)) async throws -> URL {
        let fileURL = FileManager.default.temporaryDirectory
            .appendingPathComponent("wallpaper-\(preset.id)-\(UUID().uuidString).mp4")

        let writer = try AVAssetWriter(outputURL: fileURL, fileType: .mp4)
        let outputSettings: [String: Any] = [
            AVVideoCodecKey: AVVideoCodecType.h264,
            AVVideoWidthKey: Int(size.width),
            AVVideoHeightKey: Int(size.height),
            AVVideoCompressionPropertiesKey: [
                AVVideoAverageBitRateKey: 10_000_000,
                AVVideoMaxKeyFrameIntervalKey: 30
            ]
        ]

        let input = AVAssetWriterInput(mediaType: .video, outputSettings: outputSettings)
        input.expectsMediaDataInRealTime = false

        let adaptor = AVAssetWriterInputPixelBufferAdaptor(
            assetWriterInput: input,
            sourcePixelBufferAttributes: [
                kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA,
                kCVPixelBufferWidthKey as String: Int(size.width),
                kCVPixelBufferHeightKey as String: Int(size.height)
            ]
        )

        guard writer.canAdd(input) else { throw ExportError.inputRejected }
        writer.add(input)

        guard writer.startWriting() else { throw ExportError.writerFailed }
        writer.startSession(atSourceTime: .zero)

        let totalFrames = max(1, Int(duration * Double(fps)))

        for index in 0..<totalFrames {
            let time = Double(index) / Double(fps)
            let buffer = try renderFrame(preset: preset, settings: settings, time: time, size: size)

            while !adaptor.assetWriterInput.isReadyForMoreMediaData {
                try await Task.sleep(nanoseconds: 1_000_000)
            }

            let presentationTime = CMTime(value: CMTimeValue(index), timescale: fps)
            guard adaptor.append(buffer, withPresentationTime: presentationTime) else {
                throw ExportError.appendFailed
            }
        }

        input.markAsFinished()
        await writer.finishWriting()

        guard writer.status == .completed else { throw ExportError.writerFailed }
        return fileURL
    }

    private func renderFrame(preset: WallpaperPreset,
                             settings: RenderSettings,
                             time: TimeInterval,
                             size: CGSize) throws -> CVPixelBuffer {
        var pixelBuffer: CVPixelBuffer?
        let attributes: [String: Any] = [
            kCVPixelBufferCGImageCompatibilityKey as String: true,
            kCVPixelBufferCGBitmapContextCompatibilityKey as String: true,
            kCVPixelBufferIOSurfacePropertiesKey as String: [:]
        ]

        let status = CVPixelBufferCreate(kCFAllocatorDefault,
                                         Int(size.width),
                                         Int(size.height),
                                         kCVPixelFormatType_32BGRA,
                                         attributes as CFDictionary,
                                         &pixelBuffer)
        guard status == kCVReturnSuccess, let buffer = pixelBuffer else {
            throw ExportError.pixelBufferFailed
        }

        CVPixelBufferLockBaseAddress(buffer, [])
        defer { CVPixelBufferUnlockBaseAddress(buffer, []) }

        guard let baseAddress = CVPixelBufferGetBaseAddress(buffer) else {
            throw ExportError.pixelBufferFailed
        }

        let bytesPerRow = CVPixelBufferGetBytesPerRow(buffer)
        let bitmapInfo = CGImageAlphaInfo.premultipliedFirst.rawValue | kCGBitmapByteOrder32Little.rawValue

        guard let context = CGContext(data: baseAddress,
                                      width: Int(size.width),
                                      height: Int(size.height),
                                      bitsPerComponent: 8,
                                      bytesPerRow: bytesPerRow,
                                      space: CGColorSpaceCreateDeviceRGB(),
                                      bitmapInfo: bitmapInfo) else {
            throw ExportError.pixelBufferFailed
        }

        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1, y: -1)

        WallpaperRenderer.render(preset: preset,
                                 settings: settings,
                                 time: time,
                                 motion: .zero,
                                 in: context,
                                 size: size)

        return buffer
    }
}
