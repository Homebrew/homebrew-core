class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.44.6.tar.gz"
  sha256 "1e058e4dddcf1a6ea53ecbeb24da8f06c3e762c7e7e143ac1deaacccb16eec55"
  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "64097d967738decbd341baa3d17017028aaf65adcf4fce3cbf8ea166c9bff241" => :catalina
    sha256 "96f820d08a8f0b9e1bd986abf792730ffa4365af822621d11780dae555d5fe76" => :mojave
    sha256 "df268070fc2ce986e6a33fcef5ecccb6aa14dff2e48f9723568ee2f43fe16efc" => :high_sierra
  end

  depends_on :xcode => ["10.1", :build]

  def install
    xcodebuild "-project",
        "SwiftFormat.xcodeproj",
        "-scheme", "SwiftFormat (Command Line Tool)",
        "CODE_SIGN_IDENTITY=",
        "SYMROOT=build", "OBJROOT=build"
    bin.install "build/Release/swiftformat"
  end

  test do
    (testpath/"potato.swift").write <<~EOS
      struct Potato {
        let baked: Bool
      }
    EOS
    system "#{bin}/swiftformat", "#{testpath}/potato.swift"
  end
end
