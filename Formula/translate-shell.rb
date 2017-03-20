class TranslateShell < Formula
  desc "Command-line translator using Google Translate and more"
  homepage "https://www.soimort.org/translate-shell"
  url "https://github.com/soimort/translate-shell/archive/v0.9.6.1.tar.gz"
  sha256 "1c4bb79a0c33cf4482c738371cb6f4ab8994dec8b71509df77571668f8e18b41"
  head "https://github.com/soimort/translate-shell.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "77ef19f70839d19352cbecb7b4b32ad331685b6c049fa258ee774e89f40b9191" => :sierra
    sha256 "77ef19f70839d19352cbecb7b4b32ad331685b6c049fa258ee774e89f40b9191" => :el_capitan
    sha256 "77ef19f70839d19352cbecb7b4b32ad331685b6c049fa258ee774e89f40b9191" => :yosemite
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
