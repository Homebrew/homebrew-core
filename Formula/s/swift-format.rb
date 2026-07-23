class SwiftFormat < Formula
  desc "Formatting technology for Swift source code"
  homepage "https://github.com/swiftlang/swift-format"
  url "https://github.com/swiftlang/swift-format.git",
      tag:      "603.0.0",
      revision: "d54c5be7afba3e5f52ae29e2371e444a3c2a49c1"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/swiftlang/swift-format.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c97743f7ae8b7b6284d13b4266f352f8a15c2a6c3783d1ae635d6782a8d1ad69"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a32eef7ab3a18682cc5865060d25801dd948936704ff82f50cc0afeec1416ca9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18229678d294ef981b9ecff8b943987a8088c484403915ba4c3c219fbc50dc43"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1dc85faacb255a5f82013217a49f2fce1a1b1dcbb6ee1d23b8ee148a37a4257"
    sha256 cellar: :any,                 arm64_linux:   "38877c0e9a2c0a0572367c0ab80fbdf3504df8938bfeceb631f21ce7e26aaf46"
    sha256 cellar: :any,                 x86_64_linux:  "5d7a36152babd3b75ff6ae23a08c361b553b6bf7bdec53f54b67d5ffa4ca8f22"
  end

  # The bottles are built on systems with the CLT installed, and do not work
  # out of the box on Xcode-only systems due to an incorrect sysroot.
  pour_bottle? only_if: :clt_installed

  depends_on xcode: ["14.0", :build]

  uses_from_macos "swift" => :build

  def install
    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib"]
    end
    system "swift", "build", *args, "-c", "release", "--product", "swift-format"
    bin.install ".build/release/swift-format"
    doc.install "Documentation/Configuration.md"
    generate_completions_from_executable(bin/"swift-format", "--generate-completion-script")
  end

  test do
    (testpath/"test.swift").write " print(  \"Hello, World\"  ) ;"
    assert_equal "print(\"Hello, World\")\n", shell_output("#{bin}/swift-format test.swift")
  end
end
