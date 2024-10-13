class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      tag:      "0.57.0",
      revision: "168fb98ed1f3e343d703ecceaf518b6cf565207b"
  license "MIT"
  head "https://github.com/realm/SwiftLint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd8609da0dbf8e9396f9f5697b2650c35217f6d5443310ab8b3aeb095cadc32e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb14bb58a7fa8e390030b9890378c097385ac0d6bd50b1003946d24feb230b72"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "52e8789623ac1ec907079762083591e1f21d90ff751da9754b3db52badfe94bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "30e8f88c492f67ce3d08181044c5849f1b9075ad00aac615551a42aa253cbed9"
    sha256 cellar: :any_skip_relocation, ventura:       "fe9e50ce478538598d5e85875ea9c0a1d61c24d83352362de02141f1467b5262"
    sha256                               x86_64_linux:  "dec908e0f1cd2b332bcf678edc36e10f7030cfc9414e733629e763283b0ada40"
  end

  depends_on macos: :ventura
  depends_on xcode: "8.0"

  uses_from_macos "swift" => :build, since: :sonoma # swift 5.10+
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
