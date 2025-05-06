class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      tag:      "0.59.1",
      revision: "625792423014cc49b0a1e5a1a5c0d6b8b3de10f9"
  license "MIT"
  head "https://github.com/realm/SwiftLint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3f41f4287ee4a4a74a2f38628f30774e6857405c48f0e3832aaa630d13d4cb7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf36eacfa4a47f013495f2152ccdfb6dde871d17d618414e3cfc559ddf023ffc"
    sha256 cellar: :any,                 arm64_ventura: "4ccd5a613a7dd6310e088e55b9cc315f455bd81f7d104ec8072ddd00dbe69bef"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b0c46a09427e091de69f7b267efca4779ed47d43b894d87e903c09e89b7a47e"
    sha256 cellar: :any,                 ventura:       "5c31fd0bf839aa606624fdd6238fa9a36fb4fea6f34b90da3a22c41856c2d136"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fed88471e745a4b402389f8005388ac603efaa0f4b8d5baa2dfd00fd7e575bd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64bfd1f18fd38050c83d117ef116cdeb69b2100da650ed589173854d67790704"
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
