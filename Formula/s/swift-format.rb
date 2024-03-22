class SwiftFormat < Formula
  desc "Formatting technology for Swift source code"
  homepage "https://github.com/apple/swift-format"
  url "https://github.com/apple/swift-format.git",
      tag:      "510.1.0",
      revision: "7996ac678197d293f6c088a1e74bb778b4e10139"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/apple/swift-format.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c437e97e800c88f93e5888967364514d11cea08d7e51a908e42789f3edce21de"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b7230ade95e61a45c86cf2f3b23847502ff79e5390d575018b970ec094d4447f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c19b042df867ea23ae2c81837c2b7c0f772a04abb55406d27f3472bca98df78f"
    sha256 cellar: :any_skip_relocation, sonoma:         "7b71e4df0cd03078c71c867b835d756de32270241338b9c7da093ff9d7b78122"
    sha256 cellar: :any_skip_relocation, ventura:        "859b0e132e9c8491a6b406fcae047acc6ea36d715a150dc4259692aaf95fc274"
    sha256 cellar: :any_skip_relocation, monterey:       "b3c52a501c90d3f04e78c5ca3f4175503b2905eef3402c8da4954f1445330b2b"
    sha256                               x86_64_linux:   "f8dda1ab8a875599b7a0b414f5f656d6e67befe625658964c5a7ed28f7ca958d"
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
