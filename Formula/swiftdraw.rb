class Swiftdraw < Formula
  desc "Convert SVG into PDF, PNG, JPEG or SF Symbol"
  homepage "https://github.com/swhitty/SwiftDraw"
  url "https://github.com/swhitty/SwiftDraw/archive/0.13.2.tar.gz"
  sha256 "f9a13610b38b7eb78112769fa94cd79466b10a532261c383adacbe438c20e83f"
  license "Zlib"
  revision 1
  head "https://github.com/swhitty/SwiftDraw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e5ac2bf4d141aa0dd609bc29436069ec9d0a22a98bdc3e56a08149a08b65b1c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7d8cceb21a6bdaf7c21a4c0c0e78f33b8b33cd99834dc0d76cebe5550bdf6101"
    sha256 cellar: :any_skip_relocation, monterey:       "12a9af019792cc0f7557a16946b957a34dc665e4aa680b903f5381e95e8ec893"
    sha256 cellar: :any_skip_relocation, big_sur:        "6a8566ff06f352f8d85255de7c51597f4dee87ec14df2352922d883347a6296e"
    sha256                               x86_64_linux:   "900838c63cb35b53136fded97689df67b79c99e79bd61f31a937d052b804d151"
  end

  depends_on xcode: ["12.5", :build]
  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".build/release/swiftdraw"
  end

  test do
    (testpath/"fish.svg").write <<~EOS
      <?xml version="1.0" encoding="utf-8"?>
      <svg version="1.1" xmlns="http://www.w3.org/2000/svg" width="160" height="160">
        <path d="m 80 20 a 50 50 0 1 0 50 50 h -50 z" fill="pink" stroke="black" stroke-width="2" transform="rotate(45, 80, 80)"/>
      </svg>
    EOS
    system bin/"swiftdraw", testpath/"fish.svg", "--format", "sfsymbol"
    assert_path_exists testpath/"fish-symbol.svg"
  end
end
