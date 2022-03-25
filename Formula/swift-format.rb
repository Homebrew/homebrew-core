class SwiftFormat < Formula
  desc "Formatting technology for Swift source code"
  homepage "https://github.com/apple/swift-format"
  url "https://github.com/apple/swift-format.git",
      tag:      "0.50600.0",
      revision: "c06258081a3f8703f55ff6e9647b32cf3144e247"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/apple/swift-format.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f8495720a88c6eca98091cfd3f808a091902def757ee4e9a9e5725a494bb05ef"
    sha256 cellar: :any_skip_relocation, monterey:       "2255c642c46fd3df72467fde7d1bac18c107bcbc49dcbbec4243eb2a5c27c02d"
    sha256                               x86_64_linux:   "2198570510616e07930090d990bcbfbe577d36943951a59b3b6994362e6b7277"
  end

  # The bottles are built on systems with the CLT installed, and do not work
  # out of the box on Xcode-only systems due to an incorrect sysroot.
  pour_bottle? only_if: :clt_installed

  depends_on xcode: ["13.3", :build]

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
