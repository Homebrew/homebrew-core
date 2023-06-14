class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.51.12.tar.gz"
  sha256 "76f3ddfc143a89b74a3fbb72755a7b6f0f5c6bacddd2c314f997094854d54584"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "272dadfe917e9296713f7d41739d315679d77485bcedf9f5f5700523947a9635"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe6ace3786c1e3461c2d7e649e86fecf692e816ef143b1602daaf8ccca674426"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e8c39e62f11cead0543225c79a1e3f461f4a3de7595332a2068cf465bd5cb522"
    sha256 cellar: :any_skip_relocation, ventura:        "c39102257e34cc3fff2fec1f439b7d62bc5c4404c3d82d58e0b94db325aae3e2"
    sha256 cellar: :any_skip_relocation, monterey:       "19ce480a2e73c5bbed64e9b0822d99b9d705d53afc29501265933798bd571dcf"
    sha256 cellar: :any_skip_relocation, big_sur:        "653f90a848b51b79c19ec387ff1f76d892c00a4cb8824a4618793a9bc33b9b3a"
    sha256                               x86_64_linux:   "e3ef2e5695bfdcda2b072211f3071e9c06056e18e3a95a3d60d3d502aa4e8c27"
  end

  depends_on xcode: ["10.1", :build]

  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".build/release/swiftformat"
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
