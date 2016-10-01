class TranslateShell < Formula
  desc "Command-line translator using Google Translate and more"
  homepage "https://www.soimort.org/translate-shell"
  url "https://github.com/soimort/translate-shell/archive/v0.9.4.tar.gz"
  sha256 "bfc04124d2fde7924e6b5c3a11fdce7fbd2fdb1819c0b78c3fd0a7d36e330164"
  head "https://github.com/soimort/translate-shell.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "6f6c8d44ed8304a6cae6e8436085cc347d09b93baf44a5b1ad8c4d9bbf964470" => :sierra
    sha256 "4513243a0aea812f29a47b5a6c173a45e388513915e6f594a147f84acd2b8fd7" => :el_capitan
    sha256 "bb2fca4291a3cc52d1ed9752d2691003df4537b371c96201ff5bf0eafa63db6b" => :yosemite
    sha256 "614777663d78a3f0284d1ffbaa55b992c55ccbe28bdb99dba387eceb74390331" => :mavericks
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
    By default, text-to-speech functionality is provided by OS X's builtin
    `say' command. This functionality may be improved in certain cases by
    installing one of mplayer, mpv, or mpg123, all of which are available
    through `brew install'.
    EOS
  end

  test do
    assert_equal "Hello\n", shell_output("#{bin}/trans -no-init -b -s fr -t en bonjour")
  end
end
