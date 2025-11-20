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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2cb2d6b1098854c845274b4dc22921af32bf76e1e925c07c3c436af749553dd0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2914e328400b90f66824f4be94d25fb7c814ad19135a465984d65d5334bd40d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "700a3adc43be2eaa8b547f0c58c5ca6fac4b9420df1d94ddfb5bd2f71703b147"
    sha256 cellar: :any_skip_relocation, sonoma:        "3df8ef1565ac4424b04aa96d6ea70d288c33f4a65151a36eb5b1060a23b1e69b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "97119f1ea9d4d9136b62f255a20c36efef40773b942f5b8c84832638dc1d8358"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "618f29a2e8ee39339a32076172975616e090ab27889a9f1dcb2aeea07a598d8a"
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
