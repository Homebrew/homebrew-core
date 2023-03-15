class Xcbeautify < Formula
  desc "Little beautifier tool for xcodebuild"
  homepage "https://github.com/tuist/xcbeautify"
  url "https://github.com/tuist/xcbeautify.git",
      tag:      "0.18.0",
      revision: "4fa47a80f5801649e97ee3bb67b8d00337e90abd"
  license "MIT"
  head "https://github.com/tuist/xcbeautify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1e8a0f7be505d25c2299a61abce654b5454fab38cc2c24886980e4384b52952a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "28cb656704923128766d29687731800976df593be5a2d96474029c1cd68df749"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "89eed24c81acd0a326b0363dc6de29cbf183f5970d71a66f8117879c06a2d9ed"
    sha256 cellar: :any_skip_relocation, ventura:        "be5ceedbe36fa740796947fb116d7ed1484bad937d45bd1a202456a532e74f2b"
    sha256 cellar: :any_skip_relocation, monterey:       "0187587cf3b74e0cd27d35b85136278546733fc75356c703958f8a6fdecd557f"
    sha256 cellar: :any_skip_relocation, big_sur:        "fc0bd2ce8be91e7a8915aabdec8aaaf7a363f479594d86fa867ad69c03e7943d"
    sha256                               x86_64_linux:   "098c332e0f02b63458e7eb7eb564cddfff2e0b636de7e0100d8bcf0da1d03102"
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
