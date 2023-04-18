class Xcbeautify < Formula
  desc "Little beautifier tool for xcodebuild"
  homepage "https://github.com/tuist/xcbeautify"
  url "https://github.com/tuist/xcbeautify.git",
      tag:      "0.19.0",
      revision: "e3bc4e04618efa7aaf8fac4727f7fe7ffd951e08"
  license "MIT"
  head "https://github.com/tuist/xcbeautify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "87f301017b3d76ad255d9c3c615135b1827f99dbb52522d82c454c7e404c2046"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba78c805ee0cc3f239cbe17553e315c95d886f9c37147af1835b25fc5a97350f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ecfcb6e8ddccc2d7e6c59d4882fbdb372c9dd5211322f8cba52d4f3d1788917a"
    sha256 cellar: :any_skip_relocation, ventura:        "7e10dfa20b368a552c4a4b9c7dbda5b5f707b244792473b5262d961b4c462671"
    sha256 cellar: :any_skip_relocation, monterey:       "e0623eecc23efad9e1c83b3b2adc992d0931ec16b1b312d929cc429180093807"
    sha256 cellar: :any_skip_relocation, big_sur:        "2e00b12e6da090652f30a7b10ce4f71d34768f39ec0d51c9a1b8763b40ae245d"
    sha256                               x86_64_linux:   "6af0ff8f1a58266c3447057020b9cfb9ad400f5d3802d972b6525cad3abbab4d"
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
