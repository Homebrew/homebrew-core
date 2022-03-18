class Xcbeautify < Formula
  desc "Little beautifier tool for xcodebuild"
  homepage "https://github.com/thii/xcbeautify"
  url "https://github.com/thii/xcbeautify.git",
      tag:      "0.12.0",
      revision: "66c5e32dacca5f07c26c0c6cbe01c6796fcc6149"
  license "MIT"
  head "https://github.com/thii/xcbeautify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bec8cba00b7805df0eeb87cc13688ad0d692e446085695a0fec19be868baf906"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5a668f65d7477b100d07339aaa0b215f34f13f216b87d80a03380a5a176cbf50"
    sha256 cellar: :any_skip_relocation, monterey:       "1d044b8a5dc9d404db984094befacd9da51c407b0b879c1f5334271b5b43fbbb"
    sha256 cellar: :any_skip_relocation, big_sur:        "61aae5b682dab20e275b2cfb26eddbca6c1d5bfe23f3ae8eda3df2e7a7c6853c"
    sha256 cellar: :any_skip_relocation, catalina:       "fece980ac56da3f6afe260969921299c8dd7b7ae366fcad2ea96ebfa35b9ed7f"
    sha256                               x86_64_linux:   "9720c0a6db1ed83768a0df23cef1f06b69a4e250458cacb573fb3ed5f0668cfd"
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
