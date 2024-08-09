class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      tag:      "0.56.0",
      revision: "3ed1391e1d140fa9e9468b8ecba0d0f76b9752bf"
  license "MIT"
  head "https://github.com/realm/SwiftLint.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0610290fef665ecfc022ec3e8e3986224841290274a21efdee503e76b7b39bcc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af05ed001b0476ed0391778516ed92cc3ed100593a03794025c1814e6dec0cb4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e1313a57188d5a751f038596509f0186a058669abfd21aa3142457f9c16c478"
    sha256 cellar: :any_skip_relocation, sonoma:         "148e407d81cedffbe76876288f78a35fee69f82d12b2fb3356ca102c2fd6d319"
    sha256 cellar: :any_skip_relocation, ventura:        "709d73d12dd3adf64e276b04e94949749b5073f7ca946e0ead585557cfe9277c"
    sha256 cellar: :any_skip_relocation, monterey:       "30ea7b1e56634ccd521ffe86a93372e02004cf25b0a10432a5b54520a71d4139"
    sha256                               x86_64_linux:   "0f68576b2b4591e126e923278c4aa25c28aa18b7e5a9f8a3b8d7cf8eeacfe3a2"
  end

  depends_on xcode: "8.0"

  uses_from_macos "swift"

  on_sonoma :or_newer do
    depends_on xcode: ["15.3", :build]
  end
  on_ventura :or_older do
    depends_on "swift" => :build
  end

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
