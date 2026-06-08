class Swiftdraw < Formula
  desc "Convert SVG into PDF, PNG, JPEG or SF Symbol"
  homepage "https://github.com/swhitty/SwiftDraw"
  url "https://github.com/swhitty/SwiftDraw/archive/refs/tags/0.27.0.tar.gz"
  sha256 "f8cd76a17e9d630e60639ab4a1d2f5bf90e8404a7e3a1f15a79ce8919c76134d"
  license "Zlib"
  head "https://github.com/swhitty/SwiftDraw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9860713c999ea29ab81e6351c350ff12212b0336729e5f8b8a418ca0520522b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "525ecdd41cda12675fb3f02d4d75c17f984a0fafef3b21b7ac002a47d3cc7160"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc882035885a98546a93eb93d5a3b21edb6983fe9c3dd2a1f45ee2dfbcfe163d"
    sha256 cellar: :any_skip_relocation, sonoma:        "5332f74973a30b2b62cbbed253d4f2912fbb13f8c9229c9753a15599ccdc7f40"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ca202714934f64462d5bf5c1616bbaed44eef28543adc71c83cd6001bcf66d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "596db70b9e5539d5c640134776bbf211fe5050ee4f6f9c8fa32108354fc89fda"
  end

  depends_on xcode: ["16.0", :build]

  uses_from_macos "swift" => :build
  uses_from_macos "libxml2"

  def install
    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib", "-Xswiftc", "-use-ld=ld"]
    end
    system "swift", "build", *args, "--configuration", "release"
    bin.install ".build/release/swiftdrawcli" => "swiftdraw"
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
