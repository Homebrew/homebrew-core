class Rogue < Formula
  desc "Dungeon crawling video game"
  # Historical homepage: https://web.archive.org/web/20160604020207/rogue.rogueforge.net/
  homepage "https://sourceforge.net/projects/roguelike/"
  url "https://src.fedoraproject.org/repo/pkgs/rogue/rogue5.4.4-src.tar.gz/033288f46444b06814c81ea69d96e075/rogue5.4.4-src.tar.gz"
  sha256 "7d37a61fc098bda0e6fac30799da347294067e8e079e4b40d6c781468e08e8a1"

  livecheck do
    url "https://src.fedoraproject.org/repo/pkgs/rogue/"
    regex(/href=.*?rogue-?v?(\d+(?:\.\d+)+)(?:-src)?\.t/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c73ef712b35b6ba4c3339828add299a2ce8d53dd35a455d439f9639b484e99d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1cfeb02e30c14d89cf9d831c553a06eb17a6d6d27734c215e3ee7e72ab0c7c76"
    sha256 cellar: :any_skip_relocation, monterey:       "0c169854e9edcfdf99c7c52e5fbfb39dbf883c74f076097aaf3027daf9f2064b"
    sha256 cellar: :any_skip_relocation, big_sur:        "c6e8bb630a966cd8885e378242f9175ffd8327e26ec1ed679016302b437a5156"
    sha256 cellar: :any_skip_relocation, catalina:       "c576555f6857ff3ec7f0b2e39625d3c1f86989315b735a5e27d9416c095e5efc"
    sha256 cellar: :any_skip_relocation, mojave:         "7a7a380bb29967b8e795aa2407e8f205752b93952082491e20fff84394819294"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2edb3e1d6fb4af2f87d065012e68d09abda6035c5f4394d685336d0763f31869"
  end

  uses_from_macos "ncurses"

  def install
    # Fix main.c:241:11: error: incomplete definition of type 'struct _win_st'
    ENV.append "CPPFLAGS", "-DNCURSES_OPAQUE=0"

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    inreplace "config.h", "rogue.scr", "#{var}/rogue/rogue.scr"

    inreplace "Makefile" do |s|
      # Take out weird man install script and DIY below
      s.gsub! "-if test -d $(man6dir) ; then $(INSTALL) -m 0644 rogue.6 $(DESTDIR)$(man6dir)/$(PROGRAM).6 ; fi", ""
      s.gsub! "-if test ! -d $(man6dir) ; then $(INSTALL) -m 0644 rogue.6 $(DESTDIR)$(mandir)/$(PROGRAM).6 ; fi", ""
    end

    if OS.linux?
      inreplace "mdport.c", "#ifdef NCURSES_VERSION",
        "#ifdef NCURSES_VERSION\nTERMTYPE *tp = (TERMTYPE *) (cur_term);"
      inreplace "mdport.c", "cur_term->type.Strings", "tp->Strings"
    end

    system "make", "install"
    man6.install gzip("rogue.6")
    libexec.mkpath
    (var/"rogue").mkpath
  end

  test do
    system "#{bin}/rogue", "-s"
  end
end
