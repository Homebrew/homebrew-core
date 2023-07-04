class Swiftdraw < Formula
  desc "Convert SVG into PDF, PNG, JPEG or SF Symbol"
  homepage "https://github.com/swhitty/SwiftDraw"
  url "https://github.com/swhitty/SwiftDraw/archive/0.14.1.tar.gz"
  sha256 "297cc70ebf350d14ebfd48b319ca6cd706311e0ce57f085178a0bbc8591a9f09"
  license "Zlib"
  head "https://github.com/swhitty/SwiftDraw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "176262559a36e0bbe95ff361292df2d0692ef7451d394f045df45c2e3394562f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "030ab1dda64e6be2cd5b29437cf162cb269bd01b339ebb377572ec8dc597651f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a6a6831f0649221be46a576985355ea8b896ba1d138d039b44d2dac68ca03f51"
    sha256 cellar: :any_skip_relocation, ventura:        "ba33ea20488197f0c925202281e89e2db163299acbe3149196e3baf9cbc6100f"
    sha256 cellar: :any_skip_relocation, monterey:       "e8af09248e5a115f463f96b62f429c9f9cf61a96ab90d30032ef4ebdbffa86f5"
    sha256 cellar: :any_skip_relocation, big_sur:        "42b420507632dae15daa8ffc903243e73cc60bb4cf0e3c07d71a8c74d9f370e3"
    sha256                               x86_64_linux:   "71812c45b3fbeb326a318b40acd93b6bf13fade9e0cee5ef64831b1e3ad20c9f"
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
