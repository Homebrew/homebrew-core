class TranslateShell < Formula
  desc "Command-line translator using Google Translate and more"
  homepage "https://www.soimort.org/translate-shell"
  url "https://github.com/soimort/translate-shell/archive/v0.9.6.tar.gz"
  sha256 "285cf25b06ae29645065c53ac39e00bc0024688e721c108932b780cc1a225e53"
  head "https://github.com/soimort/translate-shell.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "240b83d8a753fa0ad40afb0e9f20b5adcfa4eed3509fd978d092d1a8f9ad1892" => :sierra
    sha256 "240b83d8a753fa0ad40afb0e9f20b5adcfa4eed3509fd978d092d1a8f9ad1892" => :el_capitan
    sha256 "240b83d8a753fa0ad40afb0e9f20b5adcfa4eed3509fd978d092d1a8f9ad1892" => :yosemite
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
