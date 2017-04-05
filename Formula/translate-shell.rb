class TranslateShell < Formula
  desc "Command-line translator using Google Translate and more"
  homepage "https://www.soimort.org/translate-shell"
  url "https://github.com/soimort/translate-shell/archive/v0.9.6.2.tar.gz"
  sha256 "db0e322cd1361c45d0740049e11d349be61ada859d5daa59c53396d0ccbd5e4b"
  head "https://github.com/soimort/translate-shell.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "d89626dcfe9c8ea08b08f8775efb84434298ee9ea6fc1c6c4c9488265ba378cb" => :sierra
    sha256 "5b5172976d949885f323bfc4996b060942b61aa2b7ac71e8c4216715065dcf4e" => :el_capitan
    sha256 "5b5172976d949885f323bfc4996b060942b61aa2b7ac71e8c4216715065dcf4e" => :yosemite
  end

  depends_on "fribidi"
  depends_on "gawk"
  depends_on "rlwrap"

  def install
    system "make"
    bin.install "build/trans"
    man1.install "man/trans.1"
  end

  def caveats; <<-EOS.undent
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
