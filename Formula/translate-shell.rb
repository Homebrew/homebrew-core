class TranslateShell < Formula
  desc "Command-line translator using Google Translate and more"
  homepage "https://www.soimort.org/translate-shell"
  url "https://github.com/soimort/translate-shell/archive/v0.9.6.12.tar.gz"
  sha256 "4c4843a8c66276190535b8435775ecb5d9c8286083a33cdbe2db608eba93ca97"
  license "Unlicense"
  head "https://github.com/soimort/translate-shell.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7cec38b70fbd8dbe6a45d76eb290b6c906e00e32029487c2cd6328bc5d6108e2"
    sha256 cellar: :any_skip_relocation, big_sur:       "d45fe158215b99a8f120db0b02fd139ab0401154cb910ff9b79664a1c1e1d64e"
    sha256 cellar: :any_skip_relocation, catalina:      "858d52386202bbcb1313a72b642d9d5f4cbfe2ca35fd9556f6cf5275d7d2b9a1"
    sha256 cellar: :any_skip_relocation, mojave:        "858d52386202bbcb1313a72b642d9d5f4cbfe2ca35fd9556f6cf5275d7d2b9a1"
    sha256 cellar: :any_skip_relocation, high_sierra:   "858d52386202bbcb1313a72b642d9d5f4cbfe2ca35fd9556f6cf5275d7d2b9a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58c6925d91ce326635abb6614b951e33aa14c7b565a3c73cc854870d3f896c59"
    sha256 cellar: :any_skip_relocation, all:           "58c6925d91ce326635abb6614b951e33aa14c7b565a3c73cc854870d3f896c59"
  end

  depends_on "fribidi"
  depends_on "gawk"
  depends_on "rlwrap"

  on_linux do
    depends_on "util-linux"
  end

  def install
    system "make"
    bin.install "build/trans"
    man1.install "man/trans.1"
  end

  def caveats
    <<~EOS
      By default, text-to-speech functionality is provided by macOS's builtin
      `say' command. This functionality may be improved in certain cases by
      installing one of mplayer, mpv, or mpg123, all of which are available
      through `brew install'.
    EOS
  end

  test do
    assert_equal "hello\n",
      shell_output("#{bin}/trans -no-init -b -s fr -t en bonjour").downcase
  end
end
