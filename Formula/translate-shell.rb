class TranslateShell < Formula
  desc "Command-line translator using Google Translate and more"
  homepage "https://www.soimort.org/translate-shell"
  url "https://github.com/soimort/translate-shell/archive/v0.9.6.10.tar.gz"
  sha256 "18c23af071ab5ae8653a5d0d1c50784b32c4a51efd9e05da07f888a6a6428958"
  head "https://github.com/soimort/translate-shell.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "cdb64cb73dd0d2e4911d489a82f7f7ce03f96f65c403324ee5e62107f9a24d18" => :mojave
    sha256 "f942f0e292e4667bbdbe12a6afbe329504ba5659645e2e375cfd4eee4676b3ed" => :high_sierra
    sha256 "f942f0e292e4667bbdbe12a6afbe329504ba5659645e2e375cfd4eee4676b3ed" => :sierra
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
