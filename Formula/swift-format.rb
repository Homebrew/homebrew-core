class SwiftFormat < Formula
  desc "Formatting technology for Swift source code"
  homepage "https://github.com/apple/swift-format"
  url "https://github.com/apple/swift-format.git",
      tag:      "0.50500.0",
      revision: "f872223e16742fd97fabd319fbf4a939230cc796"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/apple/swift-format.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "53959426e357b8be149cd84141c22df630a6d0c8e5097d7353cce3cdfb3738f6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "64fe92f2761fd21ec2377ec8cb51f9850ec9d6241390d719936bad05ac937d2e"
    sha256 cellar: :any_skip_relocation, monterey:       "3b5dc99305ebf489c4f465bb9df393a9c9a9de40814288c4b12110a02b35d6c3"
    sha256 cellar: :any_skip_relocation, big_sur:        "61d4b88004916e7d4456bef630017eebf0636c33cb1086958d200505c1d2a369"
  end

  # The bottles are built on systems with the CLT installed, and do not work
  # out of the box on Xcode-only systems due to an incorrect sysroot.
  pour_bottle? only_if: :clt_installed

  depends_on xcode: ["13.0", :build]

  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/swift-format"
    doc.install "Documentation/Configuration.md"
  end

  test do
    (testpath/"test.swift").write " print(  \"Hello, World\"  ) ;"
    assert_equal "print(\"Hello, World\")\n", shell_output("#{bin}/swift-format test.swift")
  end
end
