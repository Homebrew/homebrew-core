class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      tag:      "0.62.2",
      revision: "da9d742874d88f6d5d0f7b315d1fcf12655f2311"
  license "MIT"
  revision 1
  head "https://github.com/realm/SwiftLint.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ed586726c1623ba93c47dc0ba61269a86ab5e1a85ff7be4612208aaa0d205fde"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6eea04003f353ad0990a495cd868b9b365614d961017d62aaf53492920515f7a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "863e5f72419206216175b73077d7b81b97841a09fae2526faa6b35437fc8902a"
    sha256 cellar: :any_skip_relocation, sonoma:        "86393786858e99c7411d1b1a21164671e336abbbce89d6168af718b33974f8cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "276275c4ba04aeb34c2211fe533116b3ad8530ccb212ae18f4b2a678e6f5141d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a68241403223541dd3999112631bbae0a2185d8c31acbff20003ad41a1b13c19"
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
