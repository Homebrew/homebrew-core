class TranslateShell < Formula
  desc "Command-line translator using Google Translate and more"
  homepage "https://www.soimort.org/translate-shell"
  url "https://github.com/soimort/translate-shell/archive/v0.9.6.5.tar.gz"
  sha256 "6d9ae244e6dbf42466dec00dd0b955659ba275d7e780bbd101c27c9325d413ef"
  head "https://github.com/soimort/translate-shell.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "b31f0952d8dfe8829a80a86547bca825a3f6ffcce2a7d101fc0219b6e600f9f7" => :high_sierra
    sha256 "b31f0952d8dfe8829a80a86547bca825a3f6ffcce2a7d101fc0219b6e600f9f7" => :sierra
    sha256 "b31f0952d8dfe8829a80a86547bca825a3f6ffcce2a7d101fc0219b6e600f9f7" => :el_capitan
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
