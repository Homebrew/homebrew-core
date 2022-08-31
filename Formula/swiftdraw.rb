class Swiftdraw < Formula
  desc "Convert SVG into PDF, PNG, JPEG or SF Symbol"
  homepage "https://github.com/swhitty/SwiftDraw"
  url "https://github.com/swhitty/SwiftDraw/archive/0.13.1.tar.gz"
  sha256 "50b4695de745bde8c4a4e6c096dfee2a809d0c099836a0948d6573793b9b74fb"
  license "Zlib"
  head "https://github.com/swhitty/SwiftDraw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3e86a4a23a2021bec540459705ef24b31f1227cc846a3d8eecc932c94a7bf52"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9803d2c1c5022ec06c75ee82da4c81037770fa24248be4ba6f17b6b15a154da2"
    sha256 cellar: :any_skip_relocation, monterey:       "232741f96be5bf9188f2dde3b05ccd8d8a3e44c60e9520742d57bfab15c3e1e8"
    sha256 cellar: :any_skip_relocation, big_sur:        "1adb8ed5498786091b1f680f6d8dc0f6ecb71ed018fc17c79f106da1fe5e618f"
    sha256                               x86_64_linux:   "dd9a7c47c8aded52df8c1450e69661da9009c9daaef45f18715e96fd6af29c48"
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
