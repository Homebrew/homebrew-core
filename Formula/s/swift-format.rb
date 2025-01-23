class SwiftFormat < Formula
  desc "Formatting technology for Swift source code"
  homepage "https://github.com/swiftlang/swift-format"
  url "https://github.com/swiftlang/swift-format.git",
      tag:      "600.0.0",
      revision: "65f9da9aad84adb7e2028eb32ca95164aa590e3b"
  license "Apache-2.0"
  revision 1
  version_scheme 1
  head "https://github.com/swiftlang/swift-format.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4bee0106201ba2a3036576610e61832b97fb65292c194f52fc15d62e1bdb2243"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac50e5269ecc0bffb70a6c5077f97954e2e51c9158a3bfa36b86d89f9d6c5e43"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7fb047e8f80a72e5d8d7ae50c496d0cf59dd3ab654ce6048e4b7fa7b85afe69a"
    sha256 cellar: :any_skip_relocation, sonoma:        "a99a19c9fc177a57b2577e3c1b30feb70f13388fc9c4e4ea7968f783058e09a0"
    sha256 cellar: :any_skip_relocation, ventura:       "a652f68cc4bed9c3186b66c8ee68e79b7387d37943aaff0a0c2d4197367b73fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1949fcb7f1b943fa5b0216bc6f18e12dc369c0538b093786332f851f22b0b03"
  end

  # The bottles are built on systems with the CLT installed, and do not work
  # out of the box on Xcode-only systems due to an incorrect sysroot.
  pour_bottle? only_if: :clt_installed

  depends_on xcode: ["14.0", :build]

  uses_from_macos "swift" => :build

  # Fix hang on Linux.
  # Remove with the next release.
  patch do
    url "https://github.com/swiftlang/swift-format/commit/5a1348bd9d08227b2af8a94e95bf2ebb1ca1817e.patch?full_index=1"
    sha256 "0b012627c97d077cbbbc5c9427bab8f6a5c03b150116b2370eaa43bb0b4d9454"
  end

  def install
    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib"]
    end
    system "swift", "build", *args, "-c", "release", "--product", "swift-format"
    bin.install ".build/release/swift-format"
    doc.install "Documentation/Configuration.md"
  end

  test do
    (testpath/"test.swift").write " print(  \"Hello, World\"  ) ;"
    assert_equal "print(\"Hello, World\")\n", shell_output("#{bin}/swift-format test.swift")
  end
end
