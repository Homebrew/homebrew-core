class TranslateShell < Formula
  desc "Command-line translator using Google Translate and more"
  homepage "https://www.soimort.org/translate-shell"
  url "https://github.com/soimort/translate-shell/archive/v0.9.6.3.tar.gz"
  sha256 "25ee1eafdeb0400113e9d37ff9d862093c6fb1bdcbab562260654e3f76c2328f"
  head "https://github.com/soimort/translate-shell.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "1b447e0a7cedd75e0ba65d75e3004179cb70f1f7e4c4a1ec6b53ec5b6014eeaf" => :sierra
    sha256 "15145b830de4e3bc2ee03314b026035637df9c5aaf933def03aaf21a44ec1e55" => :el_capitan
    sha256 "15145b830de4e3bc2ee03314b026035637df9c5aaf933def03aaf21a44ec1e55" => :yosemite
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
