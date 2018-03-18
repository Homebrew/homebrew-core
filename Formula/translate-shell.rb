class TranslateShell < Formula
  desc "Command-line translator using Google Translate and more"
  homepage "https://www.soimort.org/translate-shell"
  url "https://github.com/soimort/translate-shell/archive/v0.9.6.7.tar.gz"
  sha256 "25f90bd755b457602928d4efbdd8db64129013f2943d1d9c1316c6854736db46"
  head "https://github.com/soimort/translate-shell.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "5cb3a97cfccd9f5290c7b32305ce1fc614c553bc221a7042dc518a349e666702" => :high_sierra
    sha256 "5cb3a97cfccd9f5290c7b32305ce1fc614c553bc221a7042dc518a349e666702" => :sierra
    sha256 "5cb3a97cfccd9f5290c7b32305ce1fc614c553bc221a7042dc518a349e666702" => :el_capitan
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
