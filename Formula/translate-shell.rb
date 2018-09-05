class TranslateShell < Formula
  desc "Command-line translator using Google Translate and more"
  homepage "https://www.soimort.org/translate-shell"
  url "https://github.com/soimort/translate-shell/archive/v0.9.6.8.tar.gz"
  sha256 "3cfdd5be799859465fc6b96e8fbd880a881395ae12c0e83be7a72434f914cc9f"
  head "https://github.com/soimort/translate-shell.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "c6e76900d893f00152cb67b92f902deb8f7ca082ee8353b8a50fe1062f1afbad" => :mojave
    sha256 "aad8fd83587c326a972774992d43f2ecf27a0b92a0c64c2c1ebbf9a89c30eb96" => :high_sierra
    sha256 "aad8fd83587c326a972774992d43f2ecf27a0b92a0c64c2c1ebbf9a89c30eb96" => :sierra
    sha256 "aad8fd83587c326a972774992d43f2ecf27a0b92a0c64c2c1ebbf9a89c30eb96" => :el_capitan
  end

  depends_on "fribidi"
  depends_on "gawk"
  depends_on "rlwrap"

  def install
    system "make"
    bin.install "build/trans"
    man1.install "man/trans.1"
  end

  def caveats; <<~EOS
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
