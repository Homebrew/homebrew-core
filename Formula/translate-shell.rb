class TranslateShell < Formula
  desc "Command-line translator using Google Translate and more"
  homepage "https://www.soimort.org/translate-shell"
  url "https://github.com/soimort/translate-shell/archive/v0.9.6.11.tar.gz"
  sha256 "589505248212726dff2b3e8828514036491f019fcee8657c0d94bb1a5dac6c5b"
  head "https://github.com/soimort/translate-shell.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "f16cf843284d8e77929694f584674b6cc5b3a39a8b84b9440ce4f0bdf11b8d2e" => :mojave
    sha256 "f16cf843284d8e77929694f584674b6cc5b3a39a8b84b9440ce4f0bdf11b8d2e" => :high_sierra
    sha256 "826b7449d275fb60ad3e16bc42001e5073669e056196bd4de5a1a14a37955332" => :sierra
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
