class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      tag:      "0.58.2",
      revision: "eba420f77846e93beb98d516b225abeb2fef4ca2"
  license "MIT"
  head "https://github.com/realm/SwiftLint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88296c32a4fe4de3cdadd1a1bc3df7c583d404b254684e1e67b2b98990bf2685"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "418915019f2a7f98101c2ab953d6250973f2e7dbfe369d0c752d49ecb7405dfb"
    sha256 cellar: :any,                 arm64_ventura: "29c93dcadbb55523ed14bdee545cf2cb2e51de4f6e3e40c91685f5cab7cb6c14"
    sha256 cellar: :any_skip_relocation, sonoma:        "c02c9ac0b73657587745e1950a7ac2b734bb851f6027857d967424296b9c2895"
    sha256 cellar: :any,                 ventura:       "b1d6870415a7ef30d994bf4856512ca82df3152ee716964f2fb09614845d6f12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5bdcb3773b806fa9f400bd2a82e5639525ee5faadeb51adda9fd7d59892ea5b7"
  end

  depends_on macos: :ventura
  depends_on xcode: "8.0"

  uses_from_macos "swift" => :build, since: :sonoma # swift 5.10+
  uses_from_macos "curl"
  uses_from_macos "libxml2"

  def install
    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib"]
    end
    system "swift", "build", *args, "--configuration", "release", "--product", "swiftlint"
    bin.install ".build/release/swiftlint"
    generate_completions_from_executable(bin/"swiftlint", "--generate-completion-script")
  end

  test do
    (testpath/"Test.swift").write "import Foundation"
    assert_match "Test.swift:1:1: warning: Trailing Newline Violation: " \
                 "Files should have a single trailing newline (trailing_newline)",
      shell_output("SWIFTLINT_SWIFT_VERSION=5 SWIFTLINT_DISABLE_SOURCEKIT=1 #{bin}/swiftlint lint --no-cache").chomp
    assert_match version.to_s,
      shell_output("#{bin}/swiftlint version").chomp
  end
end
