class Xcbeautify < Formula
  desc "Little beautifier tool for xcodebuild"
  homepage "https://github.com/tuist/xcbeautify"
  url "https://github.com/tuist/xcbeautify.git",
      tag:      "0.13.0",
      revision: "a3f5db18e7218a3817031b1b8227b1cb5704cb93"
  license "MIT"
  head "https://github.com/tuist/xcbeautify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68ad1f6b9862d756a3ff9ba893b09ecb8f7b6572ce0d8f82cf64cad6736b3932"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "388db60d60c9a11545d0b4a558aeb4d8e0202b4d5b2f03e250959449e2a803b0"
    sha256 cellar: :any_skip_relocation, monterey:       "54971517fc3bdc96deef9509ccf6ec8e1715e5fb571d58616dbf3f877ae6afb3"
    sha256 cellar: :any_skip_relocation, big_sur:        "67465b77816c0254a88c79555e63ad964e0b53d9455f22f9ef36d68cbfd6738d"
    sha256 cellar: :any_skip_relocation, catalina:       "63b7eaada4012033b5bbd0cce21b03691e446283faa5770a2b5ba9da3e383bdc"
    sha256                               x86_64_linux:   "602e001f5c1660034c0e4688ad7ac30293cfab880f932849f186c563c45b589e"
  end

  depends_on xcode: ["11.4", :build]

  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".build/release/xcbeautify"
  end

  test do
    log = "CompileStoryboard /Users/admin/MyApp/MyApp/Main.storyboard (in target: MyApp)"
    assert_match "[\u{1B}[36mMyApp\u{1B}[0m] \u{1B}[1mCompiling\u{1B}[0m Main.storyboard",
      pipe_output("#{bin}/xcbeautify", log).chomp
    assert_match version.to_s,
      shell_output("#{bin}/xcbeautify --version").chomp
  end
end
