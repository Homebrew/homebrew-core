class Xctesthtmlreport < Formula
  desc "Xcode-like HTML report for Unit and UI Tests"
  homepage "https://github.com/XCTestHTMLReport/XCTestHTMLReport"
  url "https://github.com/XCTestHTMLReport/XCTestHTMLReport/archive/refs/tags/3.0.0.tar.gz"
  sha256 "14f47fbfe9c4a62fffdfaa93c72e843a7fc85c449a7387583e81a84f248a73e8"
  license "MIT"
  head "https://github.com/XCTestHTMLReport/XCTestHTMLReport.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b207d2e506364eab5f53021fb1b2ad02bdf85415607a5387a20f5198ffd35fde"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2b21db01870e28851b191d7575931acd9a7a2725085dc428484aafd95a048bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b1cb87b9a07ebb30ac9a7319f61c92009580ff09aa1c7048770a4ab9d1191c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f1553c24536f6f0244ed7b166d671d9fd8db8472465a71b5b0d1334bf5f949e"
  end

  depends_on :macos
  depends_on xcode: "14.0"
  uses_from_macos "swift"

  def install
    system "swift", "build", *std_swift_args
    bin.install ".build/release/xchtmlreport"
    generate_completions_from_executable(bin/"xchtmlreport", "--generate-completion-script")
  end

  test do
    resource "homebrew-testdata" do
      url "https://pub-0b56a3a43f5b4adc91c743afc384fe1a.r2.dev/SanityResults.xcresult.tar.gz"
      sha256 "e04a42a99dc05910aa31e6819016e5a481553d27d0dde121840f36fdb58e57b7"
    end

    resource("homebrew-testdata").stage("SanityResult.xcresult")
    # It will generate an index.html file
    system bin/"xchtmlreport", "-r", "SanityResult.xcresult"
    assert_path_exists testpath/"index.html"
  end
end
