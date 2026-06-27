class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      tag:      "0.64.1",
      revision: "c12f1f860a489c1574b1f295f8a5070652caf331"
  license "MIT"
  head "https://github.com/realm/SwiftLint.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "714dd8792cdd70526d240e2e99bbea89fc9d9f24c4040885198a6243efe414e3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fce84ecb24d06bda0e85a0ec5cb914dd660c1782934ddde0f97a462d7002ffc5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd566faf75048bb22f2bfbf88970e318c961be45bab2407f1afed6f79ae8c122"
    sha256 cellar: :any_skip_relocation, sonoma:        "151145fea94fee40219b126e23d1f306bb57352d4a3684b85310d793d519a767"
    sha256 cellar: :any,                 arm64_linux:   "b9539f667a9c9fc07008421782f001311de6f6ec7c9239d763ff5383e6f28ed9"
    sha256 cellar: :any,                 x86_64_linux:  "706e737c71895e6728e361457018ad01baeef9a4a358d889935d452671e3d200"
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
