class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      tag:      "0.53.0",
      revision: "6d2e58271ebc14c37bf76d7c9f4082cc15bad718"
  license "MIT"
  head "https://github.com/realm/SwiftLint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "240ccda9de55d948d0c635798079074099bfcb73ffda41428900fdc748aeea7b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7b7ceb7896c6833965cc4eac9001255d8adde6c5432045d5a8ab6aea8a9e81d9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "78c2a4c3f4a2f6847b484527b0f0f916da71e3ee29e49890fd44b63fe7b38e26"
    sha256 cellar: :any_skip_relocation, sonoma:         "abdca78dd8a8bd268053b3be195fe891bb74aef5502ab3a6b871ae0c6bb04540"
    sha256 cellar: :any_skip_relocation, ventura:        "be711c707bf3b49fa0dd6e2ae576b309aad620f9b56a2c6e7b1ac5cf35cf652a"
    sha256 cellar: :any_skip_relocation, monterey:       "13487d68a971dbe035019364e19d70641af2a18c06e52925d238685b384a7979"
    sha256                               x86_64_linux:   "fbbc56fccfcfcd34564feb7325567e2ff3638d3c609396a5c4aa13311c7b26e0"
  end

  depends_on xcode: ["14.0", :build]
  depends_on xcode: "8.0"

  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release", "--product", "swiftlint"
    bin.install ".build/release/swiftlint"
    generate_completions_from_executable(bin/"swiftlint", "--generate-completion-script")
  end

  test do
    (testpath/"Test.swift").write "import Foundation"
    assert_match "Test.swift:1:1: warning: Trailing Newline Violation: " \
                 "Files should have a single trailing newline (trailing_newline)",
      shell_output("SWIFTLINT_SWIFT_VERSION=3 SWIFTLINT_DISABLE_SOURCEKIT=1 #{bin}/swiftlint lint --no-cache").chomp
    assert_match version.to_s,
      shell_output("#{bin}/swiftlint version").chomp
  end
end
