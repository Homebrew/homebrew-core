class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      tag:      "0.63.1",
      revision: "9120756b6e20e483c35433c41a4c4a9d32fc898b"
  license "MIT"
  head "https://github.com/realm/SwiftLint.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "977ce0f8e5143e0d32bb02c787918307b51aee71c78c15e09436c705c871daf5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4806babeca7a619a2db22a9674548251784f8f1fcb9ada537a39219006f6eb57"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9f5d6e4b707772ec9bcc58b5b44f15a813f21d2ee550e0fad37845f4a4c610b"
    sha256 cellar: :any_skip_relocation, sonoma:        "443de670798ba1c61aa62fd3249fd2a165df8d5ab520ee2b4b603116a2913a48"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa5bc629f5aa974fac09f198304ec9788a35a68f9601f96be66f72f263e3f8b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5dbe677dde3894375e898386bbbecf1d58b3871aee150e2a42645f3d9396f05"
  end

  depends_on macos: :ventura
  depends_on xcode: "8.0"

  uses_from_macos "swift" => :build, since: :sonoma # swift 5.10+
  uses_from_macos "curl"
  uses_from_macos "libxml2"

  def install
    if OS.mac?
      args = ["--disable-sandbox"]
    else
      libxml2_lib = Formula["libxml2"].opt_lib
      args = [
        "--static-swift-stdlib",
        "-Xlinker", "-L#{Formula["curl"].opt_lib}",
        "-Xlinker", "-L#{libxml2_lib}"
      ]
      ENV.prepend_path "LD_LIBRARY_PATH", libxml2_lib
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
