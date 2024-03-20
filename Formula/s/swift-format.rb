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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "214206bdf245c6c45474a34544c6fd3e77bd40d41230dd569adbfc9c82a525d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6c97b4e90d3767f66ed05fb88da5e22e922cfec821004fc2128153dbbfbc0ada"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb3c07d03e819d9141ea2ee7020cc545586094258721652e28c2a615415b0f9f"
    sha256 cellar: :any_skip_relocation, sonoma:         "cc9a88070e1678f82b859765bd21b6624c19494534d56eb7ccc69d3f79f73216"
    sha256 cellar: :any_skip_relocation, ventura:        "6231017fc05b1cdd848d60db53758c7d877dbb170d5fa3773805cf54159e6500"
    sha256 cellar: :any_skip_relocation, monterey:       "0ea1c6a3795133c58409b293408712a118b6d40bf00a4550a5a0278e072b3e0a"
    sha256                               x86_64_linux:   "125cf67c6d0f941746fd40b4c6c7bc9c07fb9998da63c9a080da397c313d47b4"
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
