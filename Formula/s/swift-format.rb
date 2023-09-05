class SwiftFormat < Formula
  desc "Formatting technology for Swift source code"
  homepage "https://github.com/apple/swift-format"
  url "https://github.com/apple/swift-format.git",
      tag:      "508.0.1",
      revision: "fbfe1869527923dd9f9b2edac148baccfce0dce7"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/apple/swift-format.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "74c93fb3ea0ff22fcb2ccf43328047577baa4f37637a8649f98599796096bb38"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "80cc1fc3ba11cc6b4ddfc41d92e6ec5bbe74265bfd8bef28e2af1200c693fb61"
    sha256 cellar: :any_skip_relocation, ventura:        "ad55a120d42363640a46cb75b1d18dbb3569dcfc9d3ac08f5a0a8372f696e193"
    sha256 cellar: :any_skip_relocation, monterey:       "a88400e4fef158f06820e9375c8552e48d0b54997a100671e3db8458c66e1779"
    sha256                               x86_64_linux:   "bd72a01ee943c12052f9dc34f2bd1952c4ca2d45e7fcc9fa42257a811b689c5f"
  end

  # The bottles are built on systems with the CLT installed, and do not work
  # out of the box on Xcode-only systems due to an incorrect sysroot.
  pour_bottle? only_if: :clt_installed

  depends_on xcode: ["14.0", :build]

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
