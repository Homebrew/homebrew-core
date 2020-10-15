class TranslateShell < Formula
  desc "Command-line translator using Google Translate and more"
  homepage "https://www.soimort.org/translate-shell"
  url "https://github.com/soimort/translate-shell/archive/v0.9.6.12.tar.gz"
  sha256 "4c4843a8c66276190535b8435775ecb5d9c8286083a33cdbe2db608eba93ca97"
  license "Unlicense"
  head "https://github.com/soimort/translate-shell.git", branch: "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "858d52386202bbcb1313a72b642d9d5f4cbfe2ca35fd9556f6cf5275d7d2b9a1" => :catalina
    sha256 "858d52386202bbcb1313a72b642d9d5f4cbfe2ca35fd9556f6cf5275d7d2b9a1" => :mojave
    sha256 "858d52386202bbcb1313a72b642d9d5f4cbfe2ca35fd9556f6cf5275d7d2b9a1" => :high_sierra
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
