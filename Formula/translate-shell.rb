class TranslateShell < Formula
  desc "Command-line translator using Google Translate and more"
  homepage "https://www.soimort.org/translate-shell"
  url "https://github.com/soimort/translate-shell/archive/v0.9.6.5.tar.gz"
  sha256 "6d9ae244e6dbf42466dec00dd0b955659ba275d7e780bbd101c27c9325d413ef"
  head "https://github.com/soimort/translate-shell.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "2f3521322584ee20199765e10f0ad2b049889855bfbbc9aab3b8e0e102bede2b" => :high_sierra
    sha256 "1a717f10cb42e97e8cdb7b9725fb376d2bec1f57dcc2c14ddfb52b07d93eebb2" => :sierra
    sha256 "88a2ed1d6e5a8728c332c5da83da61692058c5664dcc88f7f28806d23c43b6ee" => :el_capitan
    sha256 "88a2ed1d6e5a8728c332c5da83da61692058c5664dcc88f7f28806d23c43b6ee" => :yosemite
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
