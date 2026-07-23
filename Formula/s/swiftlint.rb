class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      tag:      "0.65.0",
      revision: "fd768ba9a0e8a4f96d550d98de6c4cf2af565cf1"
  license "MIT"
  head "https://github.com/realm/SwiftLint.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d6ce40835012e9821e8224956856f6221ae491ab379accf85f4097a92a02939f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72190a63d2befafeec18c4b65176446e619ef35c3eaa7222decc52ea6fb576c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8978e712634f0181842f3bfeeea4d16640ad5ce17e2bb56f9b811b9b5fb395c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "00f9919b5533bfaf5a7a72a90f83f3c8e55e78e11e1b101187e8df15d7197b27"
    sha256 cellar: :any,                 arm64_linux:   "d21d7f718ed3eec675f6065d7673be2824188376d2313daca2accb6aafd8402c"
    sha256 cellar: :any,                 x86_64_linux:  "044eddb77c7511520fe475b78eaa7c242aa0938123c56cd45c284a027fc5e43c"
  end

  depends_on xcode: "8.0"

  uses_from_macos "swift" => :build, since: :sonoma # swift 5.10+
  uses_from_macos "curl"
  uses_from_macos "libxml2"

  on_macos do
    depends_on macos: :ventura
  end

  def install
    if OS.mac?
      args = ["--disable-sandbox"]
    else
      libxml2_lib = formula_opt_lib("libxml2")
      args = [
        "--static-swift-stdlib",
        "-Xlinker", "-L#{formula_opt_lib("curl")}",
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
