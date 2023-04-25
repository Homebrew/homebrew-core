class SwiftFormat < Formula
  desc "Formatting technology for Swift source code"
  homepage "https://github.com/apple/swift-format"
  url "https://github.com/apple/swift-format.git",
      tag:      "508.0.0",
      revision: "3330aaa0a97fe07e764a4dc9bb032b23df3a948f"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/apple/swift-format.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da855fdcc0434e1e5991d497ee8c95dfac320f8738e3f8537c66e16a86225659"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "78a8710c07ad64bd0caf9b24e440931117588ffc9d120cf648c79d6d1241cbdb"
    sha256 cellar: :any_skip_relocation, ventura:        "a57767183e1d3d469fcef6a7b39976674c089192dad4f82d2e977979b86c28a8"
    sha256 cellar: :any_skip_relocation, monterey:       "a4e4d877cb0036e58de958540f38d438c57ed2c206cad77eee3a39ff228b3352"
    sha256                               x86_64_linux:   "417122f7fcf965caba7eb579398b3d2cac8be6bf3f3338450e0d96205b5ecb01"
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
