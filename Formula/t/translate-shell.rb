class TranslateShell < Formula
  desc "Command-line translator using Google Translate and more"
  homepage "https://www.soimort.org/translate-shell"
  url "https://github.com/soimort/translate-shell/archive/refs/tags/v0.9.7.1.tar.gz"
  sha256 "f949f379779b9e746bccb20fcd180d041fb90da95816615575b49886032bcefa"
  license "Unlicense"
  head "https://github.com/soimort/translate-shell.git", branch: "develop"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "58078d2c0655645aa195c91dc972beb161c90a4085a58bced9d2a9d9830c7b92"
  end

  depends_on "fribidi"
  depends_on "gawk"
  depends_on "rlwrap"

  on_linux do
    depends_on "util-linux"
  end

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
    ENV["LC_ALL"] = "en_US.UTF-8"
    assert_equal "hello\n",
      shell_output("#{bin}/trans -no-init -b -s es -t en hola").downcase
  end
end
