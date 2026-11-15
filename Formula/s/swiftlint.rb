class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      tag:      "0.65.1",
      revision: "6aba03e3d8302b33f106e0f922210f35ca4b52cf"
  license "MIT"
  head "https://github.com/realm/SwiftLint.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e986deaff3ecaa4dd5c1f169a0900131dd5ff56c5ec4cbf96b73b1033196e593"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1d50373afecfb6ad0dbb527de4bd678d38cf9f9a42c248e85b7235055a8db68a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a08a9e47fe0ccaf6c4eacec3961a6897393d9431dfd0fcb52767994f2ea197c4"
    sha256 cellar: :any,                 arm64_linux:       "309cb49b4012b0dcbf56b74305734209706122e074e2fb93e8e7a62e86c19c1d"
    sha256 cellar: :any,                 x86_64_linux:      "e79601d7a4c1483ed94d820ca94f8f39609728d7826f29d2aad51b9861549ab3"
  end

  depends_on xcode: "8.0"

  uses_from_macos "swift" => :build, since: :sonoma # swift 5.10+
  uses_from_macos "curl"
  uses_from_macos "libxml2"

  on_macos do
    depends_on macos: :ventura
  end

  deny_network_access!

  def fetch
    # SwiftPM tries to apply its own sandbox, which cannot nest inside the
    # build sandbox; Homebrew's sandbox still confines the whole process.
    system "swift", "package", "resolve", "--disable-sandbox"
  end

  def install
    system "swift", "build", "--product", "swiftlint", *std_swift_args
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
