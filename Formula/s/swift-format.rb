class SwiftFormat < Formula
  desc "Formatting technology for Swift source code"
  homepage "https://github.com/swiftlang/swift-format"
  url "https://github.com/swiftlang/swift-format.git",
      tag:      "604.0.0",
      revision: "15d7877c6b32926948f6520f0156657945955ea3"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/swiftlang/swift-format.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "19ad90f368d9a5627a0f45d0858c78bf13f782752a9a36bc7a355cfd9dc19430"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cb8ba1f28d1c9b1b7d490cd45eb21561a896b923493bc192983de9d206272577"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a4890bc578594b94782ec0e434097a467a1a8e94271b504e0430326a6db55fb2"
    sha256 cellar: :any,                 arm64_linux:       "c36e52a9319d336be41f946bd5098580e8f76422e16293544d82ef3a942c8f0e"
    sha256 cellar: :any,                 x86_64_linux:      "90c1263e0a1f4cd7ec4242cb7c1d79433badb7f03c01bf2b0dfcb592d0986801"
  end

  # The bottles are built on systems with the CLT installed, and do not work
  # out of the box on Xcode-only systems due to an incorrect sysroot.
  pour_bottle? only_if: :clt_installed

  uses_from_macos "swift" => :build

  on_macos do
    depends_on xcode: ["14.0", :build]
  end

  deny_network_access!

  def fetch
    # SwiftPM tries to apply its own sandbox, which cannot nest inside the
    # build sandbox; Homebrew's sandbox still confines the whole process.
    system "swift", "package", "resolve", "--disable-sandbox"
  end

  def install
    system "swift", "build", "--product", "swift-format", *std_swift_args
    bin.install ".build/release/swift-format"
    doc.install "Documentation/Configuration.md"
    generate_completions_from_executable(bin/"swift-format", "--generate-completion-script")
  end

  test do
    (testpath/"test.swift").write " print(  \"Hello, World\"  ) ;"
    assert_equal "print(\"Hello, World\")\n", shell_output("#{bin}/swift-format test.swift")
  end
end
