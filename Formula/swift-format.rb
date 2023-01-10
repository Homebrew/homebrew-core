class SwiftFormat < Formula
  desc "Formatting technology for Swift source code"
  homepage "https://github.com/apple/swift-format"
  url "https://github.com/apple/swift-format.git",
      tag:      "0.50700.0",
      revision: "3dd9b517b9e9846435aa782d769ef5825e7c2d65"
  license "Apache-2.0"
  revision 1
  version_scheme 1
  head "https://github.com/apple/swift-format.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "91d251f9f0255945a2a65f6132b59c52dcd8eaa103a7084e5e2a7c671e0a50fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bff7d3e53f5883fed71a68248d77fc1f9759fcf3249b132a3303f8a5532a6603"
    sha256 cellar: :any_skip_relocation, ventura:        "5f273a62915407e3be62f8413dd0ad63d7d65845d16776ade6b69f6490babe95"
    sha256 cellar: :any_skip_relocation, monterey:       "b1c9572263998fb745bd65f35bf1f0c096f562e69eb8f581d159e3cd27dab454"
    sha256                               x86_64_linux:   "279de283136d0794350c43b419aed6c48fd26c5e0db24226e0c6e598729308ad"
  end

  # The bottles are built on systems with the CLT installed, and do not work
  # out of the box on Xcode-only systems due to an incorrect sysroot.
  pour_bottle? only_if: :clt_installed

  depends_on xcode: ["14.0", :build]

  uses_from_macos "swift"

  def install
    # Support Swift 5.7.
    # Remove when minimum supported Swift >= 5.7.1.
    inreplace "Package.swift", '.upToNextMinor(from: "0.50700.0")', '.exact("0.50700.0")' if OS.mac? && build.stable?
    # This can likely be removed with 0.50800.0
    swift_rpath = if OS.mac?
      ["-Xlinker", "-rpath", "-Xlinker", "/Library/Developer/CommandLineTools/usr/lib/swift/macosx"]
    end

    system "swift", "build", "--disable-sandbox", "-c", "release", *swift_rpath
    bin.install ".build/release/swift-format"
    doc.install "Documentation/Configuration.md"
  end

  test do
    (testpath/"test.swift").write " print(  \"Hello, World\"  ) ;"
    assert_equal "print(\"Hello, World\")\n", shell_output("#{bin}/swift-format test.swift")
  end
end
