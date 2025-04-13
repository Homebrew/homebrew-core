class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      tag:      "0.59.0",
      revision: "ce8ca6a6e7e4038235af3d7319a872e6b87e4137"
  license "MIT"
  head "https://github.com/realm/SwiftLint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "369e0778256a04f47ad3b428bb70db9b38550c1441d7baf4d2823fdcef637d17"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77d9c43aae00bf4151c4331fb1b3a8b68858848f7f453236310d4a44965af921"
    sha256 cellar: :any,                 arm64_ventura: "0b1b861007a96a0f55822ded4745155f2cde15fd054ce59e2df8125f8468dfc5"
    sha256 cellar: :any_skip_relocation, sonoma:        "693c1b2e14823ba92917184d731377bb791d516cec624e308b39e1098dc798b5"
    sha256 cellar: :any,                 ventura:       "1ffbc1f34d865656f3f984bec6a21b8b0fb326860a258b5651326007961006f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52358167f9b62e4612a3d9fe335a121bda2ff35082f457dc845b63275bd75758"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51f9e1bf27b9912b0884d67de045288accc847ad9db83a746af34046e9478a92"
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
