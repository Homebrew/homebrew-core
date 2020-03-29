class TranslateShell < Formula
  desc "Command-line translator using Google Translate and more"
  homepage "https://www.soimort.org/translate-shell"
  url "https://github.com/soimort/translate-shell/archive/v0.9.6.11.tar.gz"
  sha256 "589505248212726dff2b3e8828514036491f019fcee8657c0d94bb1a5dac6c5b"
  head "https://github.com/soimort/translate-shell.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "a0657e3d27eb37e977dc5cd74390679ebdbdbd01efd07eb151f74f5d966d174c" => :catalina
    sha256 "36a689f6c97099a7143160efa40f2de05856f701a78ea7e0c92dc8da764c85d6" => :mojave
    sha256 "36a689f6c97099a7143160efa40f2de05856f701a78ea7e0c92dc8da764c85d6" => :high_sierra
    sha256 "7db0d8e36c4ee585719b21121e4cf26593f7b34c9678fcd2432fc50d8783359c" => :sierra
  end

  depends_on "fribidi"
  depends_on "gawk"
  depends_on "rlwrap"

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
