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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f59ef3e47e5f5dad726c372b6be145f302971104aee3ba3256587ee2f7d77337"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "355e227631c799b2c73f0f9815bf9a05e9404d0a47161d90a0d984d90c49ac97"
    sha256 cellar: :any_skip_relocation, ventura:        "eeea265a826a6651363e2970052038a0b47e11910c112a517efd2a37ec351049"
    sha256 cellar: :any_skip_relocation, monterey:       "6c087279fc6cb17d916e16457268ea617360079443fa11aa8a3d521fecd160bb"
    sha256                               x86_64_linux:   "d68e4d01e9be0aeeab34f2159bd492fbc26620d323b93613cf8a7f223343ad47"
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
