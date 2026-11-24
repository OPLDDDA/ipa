import SwiftUI
import CoreMotion
import QuartzCore

final class WallpaperDisplayView: UIView {
    var preset: WallpaperPreset = WallpaperPreset.all[0] {
        didSet { setNeedsDisplay() }
    }
    var settings: RenderSettings = .default {
        didSet { setNeedsDisplay() }
    }

    private var displayLink: CADisplayLink?
    private let motionManager = CMMotionManager()
    private var tilt: CGPoint = .zero

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }

    private func configure() {
        isOpaque = true
        backgroundColor = .black
        contentMode = .redraw

        let link = CADisplayLink(target: self, selector: #selector(tick))
        link.add(to: .main, forMode: .common)
        displayLink = link

        guard motionManager.isDeviceMotionAvailable else { return }
        motionManager.deviceMotionUpdateInterval = 1.0 / 30.0
        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] data, _ in
            guard let data else { return }
            self?.tilt = CGPoint(x: data.attitude.roll, y: data.attitude.pitch)
        }
    }

    @objc private func tick() {
        setNeedsDisplay()
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        WallpaperRenderer.render(preset: preset,
                                 settings: settings,
                                 time: CFAbsoluteTimeGetCurrent(),
                                 motion: tilt,
                                 in: context,
                                 size: bounds.size)
    }

    deinit {
        displayLink?.invalidate()
        motionManager.stopDeviceMotionUpdates()
    }
}

struct AnimatedWallpaperView: UIViewRepresentable {
    let preset: WallpaperPreset
    let settings: RenderSettings

    func makeUIView(context: Context) -> WallpaperDisplayView {
        let view = WallpaperDisplayView()
        view.preset = preset
        view.settings = settings
        return view
    }

    func updateUIView(_ view: WallpaperDisplayView, context: Context) {
        view.preset = preset
        view.settings = settings
    }
}
