class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      tag:      "0.50.3",
      revision: "a876e860ee0e166a05428f430888de5d798c0f8d"
  license "MIT"
  head "https://github.com/realm/SwiftLint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7d447fe250b531775462560ed2179b284addb279f7dd0b6d2533da12b3c9b42f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77a486aa11b6a3cfea372752d945ff5a7f20a953261449199bdb0b0ed62da336"
    sha256 cellar: :any_skip_relocation, ventura:        "d2c6d79212a79f3b1acee88ab44018eccf20e9fce12c69c31c782536f92493d6"
    sha256 cellar: :any_skip_relocation, monterey:       "af0964ac41d78b6dd2eb3affba7b1a01cdb43649196fe0bf139d72589195e110"
    sha256                               x86_64_linux:   "13328073f6c8f572ab9c5e5e1fe170b54ff43ac7038b13d602e361619cbea474"
  end

  depends_on xcode: ["14.0", :build]
  depends_on xcode: "8.0"

  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release", "--product", "swiftlint"
    bin.install ".build/release/swiftlint"
  end

  test do
    (testpath/"Test.swift").write "import Foundation"
    assert_match "Test.swift:1:1: warning: Trailing Newline Violation: " \
                 "Files should have a single trailing newline. (trailing_newline)",
      shell_output("SWIFTLINT_SWIFT_VERSION=3 SWIFTLINT_DISABLE_SOURCEKIT=1 #{bin}/swiftlint lint --no-cache").chomp
    assert_match version.to_s,
      shell_output("#{bin}/swiftlint version").chomp
  end
end
