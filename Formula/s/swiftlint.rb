class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      tag:      "0.56.1",
      revision: "586dd54db496cbcc03c1aaddb3078bab19de5739"
  license "MIT"
  head "https://github.com/realm/SwiftLint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8928f95c4dd5dabe5b5e9eb706f2e9249d075c014af8f42bdb79afbd9c1113d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9ed24e20f861a2f4bc355648487bd005739188e07d1d5fb45f2a8828dff53337"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a196319b86855eb80004ced5636a2c5d5f580e222d3a273df950af9e4a5b416"
    sha256 cellar: :any_skip_relocation, ventura:       "876de5549e9d21a2d2efb21f277d2688cef1badc665b63a05c7903434ea298aa"
    sha256                               x86_64_linux:  "4962c8d617285eb6aaeeb45c91985aefda1255b361aa3226b2522434457278de"
  end

  depends_on "swift" => :build
  depends_on macos: :ventura

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
