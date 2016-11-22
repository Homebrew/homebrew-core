class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.18.tar.gz"
  sha256 "adb81e0f52fd6a69a8f1b0446fee4b63586ed63e3f3977c603d5d70b3f25a877"

  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  depends_on :xcode => ["8.0", :build]

  def install
    xcodebuild "-project",
        "SwiftFormat.xcodeproj",
        "-scheme", "SwiftFormat (Command Line Tool)",
        "CODE_SIGN_IDENTITY=",
        "SYMROOT=build", "OBJROOT=build"
    bin.install "build/Release/swiftformat"
  end

  test do
    swift_code = <<-eos
      struct Potato {
          let baked: Bool
      }
    eos

    f = File.new("#{testpath}/potato.swift", "w")
    f.write(swift_code)
    f.close

    system "#{bin}/swiftformat", "#{testpath}/potato.swift"
  end
end
