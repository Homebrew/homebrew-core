class SwiftFormat < Formula
  desc "Formatting technology for Swift source code"
  homepage "https://github.com/apple/swift-format"
  url "https://github.com/apple/swift-format.git",
      tag:      "0.50700.0",
      revision: "3dd9b517b9e9846435aa782d769ef5825e7c2d65"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/apple/swift-format.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d6a3b4dfd7bf236247ac5f7b56fd9b104eea58bc9c8bd645055f94efe106585"
    sha256 cellar: :any_skip_relocation, monterey:       "c453684156ee2906ccd23aaba4ae936f77e05be6659dd5fb279483b75ad85976"
    sha256                               x86_64_linux:   "81360b1b643498e1f1e2a6ed9619cab252953be0ab43e0dff148290856e05fca"
  end

  # The bottles are built on systems with the CLT installed, and do not work
  # out of the box on Xcode-only systems due to an incorrect sysroot.
  pour_bottle? only_if: :clt_installed

  depends_on xcode: ["14.0", :build]

  uses_from_macos "swift"

  def install
    # Support current stable Swift.
    # Remove with Swift 5.7.1.
    inreplace "Package.swift", '.upToNextMinor(from: "0.50700.0")', '.exact("0.50700.0")'

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
