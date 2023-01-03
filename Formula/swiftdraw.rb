class Swiftdraw < Formula
  desc "Convert SVG into PDF, PNG, JPEG or SF Symbol"
  homepage "https://github.com/swhitty/SwiftDraw"
  url "https://github.com/swhitty/SwiftDraw/archive/0.13.3.tar.gz"
  sha256 "70890ec01ab523fcf250c1ec2bbf4391dc5b1b0fbd76f1061de00fa3ea119d73"
  license "Zlib"
  head "https://github.com/swhitty/SwiftDraw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "72c0627252e65b38449e26e3010968594230b62fff5205fd63d76f94ef832634"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3764e903d3c7b9c3d7963ba163406ab67a455be4c1905873635d539a371ef263"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1df37f7c05422f9ca8bf1d816dca2e5ac0c7457044faf5cdc513e179df8e4069"
    sha256 cellar: :any_skip_relocation, ventura:        "c09e8aaa1841ae306dcd0ef7e1fc3f194c4b8af8bda3d6763a64d6d27bb0e61b"
    sha256 cellar: :any_skip_relocation, monterey:       "815b624ada5c56cc59ce1fdc25ff3d4acb1c92e0c1100b4a2db138c09d2b0345"
    sha256 cellar: :any_skip_relocation, big_sur:        "1fb36beea85c1bbb221d4c44727c7ea60ece34423f360ccb41e576a2897b0065"
    sha256                               x86_64_linux:   "001d85da41cd7f64cdde18155ad34ea11d9acb41a2fd0025d981c76c59100897"
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
