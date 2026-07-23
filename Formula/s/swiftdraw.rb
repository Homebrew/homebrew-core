class Swiftdraw < Formula
  desc "Convert SVG into PDF, PNG, JPEG or SF Symbol"
  homepage "https://github.com/swhitty/SwiftDraw"
  url "https://github.com/swhitty/SwiftDraw/archive/refs/tags/0.29.0.tar.gz"
  sha256 "ef7e15f62101c58551493a501476192e8342332549c6def40fa2b2cf59d074a0"
  license "Zlib"
  head "https://github.com/swhitty/SwiftDraw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cf5dab41f48ea90e1892b34e78c1a14cbfd207592d35b497d529a2b5fb1a6468"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ae269f6fbad37593730b06001e6a4d3407a18646f1bcb46dbfb40ec5279c945"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53a7001e6da249eedfe271877f41e5fc1bf2957642c59886a0912c4d10d6deed"
    sha256 cellar: :any_skip_relocation, sonoma:        "be3626e5e775c8e9dee723ad2da9886063b9e12bf46e036494b208e8eaaf0293"
    sha256 cellar: :any,                 arm64_linux:   "a876d753899483adc64e2d9369e66067848ae24712bd7239406d2f6a31540661"
    sha256 cellar: :any,                 x86_64_linux:  "d164245b4a6fd50222425868be2d7943ecec4e0ffbb8794b6cda3f1dc1aca9b0"
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
    (testpath/"fish.svg").write <<~SVG
      <?xml version="1.0" encoding="utf-8"?>
      <svg version="1.1" xmlns="http://www.w3.org/2000/svg" width="160" height="160">
        <path d="m 80 20 a 50 50 0 1 0 50 50 h -50 z" fill="pink" stroke="black" stroke-width="2" transform="rotate(45, 80, 80)"/>
      </svg>
    SVG
    system bin/"swiftdraw", testpath/"fish.svg", "--format", "sfsymbol"
    assert_path_exists testpath/"fish-symbol.svg"
  end
end
