class TranslateShell < Formula
  desc "Command-line translator using Google Translate and more"
  homepage "https://www.soimort.org/translate-shell"
  url "https://github.com/soimort/translate-shell/archive/v0.9.6.1.tar.gz"
  sha256 "1c4bb79a0c33cf4482c738371cb6f4ab8994dec8b71509df77571668f8e18b41"
  head "https://github.com/soimort/translate-shell.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "8b74233cc15d9e55c087d3655527fe47aa6a8308f267a45ff13769a4b8d808b4" => :sierra
    sha256 "8b74233cc15d9e55c087d3655527fe47aa6a8308f267a45ff13769a4b8d808b4" => :el_capitan
    sha256 "8b74233cc15d9e55c087d3655527fe47aa6a8308f267a45ff13769a4b8d808b4" => :yosemite
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
