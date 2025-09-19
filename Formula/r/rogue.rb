class Rogue < Formula
  desc "Dungeon crawling video game"
  # Historical homepage: https://web.archive.org/web/20160604020207/rogue.rogueforge.net/
  homepage "https://sourceforge.net/projects/roguelike/"
  url "https://src.fedoraproject.org/repo/pkgs/rogue/rogue5.4.4-src.tar.gz/033288f46444b06814c81ea69d96e075/rogue5.4.4-src.tar.gz"
  sha256 "7d37a61fc098bda0e6fac30799da347294067e8e079e4b40d6c781468e08e8a1"
  license "BSD-3-Clause"

  livecheck do
    url "https://src.fedoraproject.org/repo/pkgs/rogue/"
    regex(/href=.*?rogue-?v?(\d+(?:\.\d+)+)(?:-src)?\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "b327fe2a04af7f0560f1bbfc71cb580398b772fa3078151e7e11aacc629a15c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "78ece502084d54a61267fe5b312cc9a85161bc428fc6f8785f7e5e738bcaa237"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "596bea046705fe93367152155bd753a89a490728692838f3d281e66af803d23a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eb41a1bc17c2894736afe57978b32b796793b405a238685b04c5bb4b0e8ff466"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c73ef712b35b6ba4c3339828add299a2ce8d53dd35a455d439f9639b484e99d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1cfeb02e30c14d89cf9d831c553a06eb17a6d6d27734c215e3ee7e72ab0c7c76"
    sha256 cellar: :any_skip_relocation, sonoma:         "2e0cbcc68239387495a09dd1786e0691f725b9812472fcc13563021d1fcb44cc"
    sha256 cellar: :any_skip_relocation, ventura:        "cbb8530b652299bddc7a997cbb51205f58a89f88ed43a06dac27e784886deb11"
    sha256 cellar: :any_skip_relocation, monterey:       "0c169854e9edcfdf99c7c52e5fbfb39dbf883c74f076097aaf3027daf9f2064b"
    sha256 cellar: :any_skip_relocation, big_sur:        "c6e8bb630a966cd8885e378242f9175ffd8327e26ec1ed679016302b437a5156"
    sha256 cellar: :any_skip_relocation, catalina:       "c576555f6857ff3ec7f0b2e39625d3c1f86989315b735a5e27d9416c095e5efc"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "6010fd6661da3ce1ab2a3115fa4776827e91a7da713a6c13ec5db192edcfd3c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2edb3e1d6fb4af2f87d065012e68d09abda6035c5f4394d685336d0763f31869"
  end

  uses_from_macos "ncurses"

  def install
    # Fix main.c:241:11: error: incomplete definition of type 'struct _win_st'
    ENV.append "CPPFLAGS", "-DNCURSES_OPAQUE=0 -DNCURSES_INTERNALS"

    args = []
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", *args, *std_configure_args

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
    man6.install Utils::Gzip.compress("rogue.6")
    libexec.mkpath
    (var/"rogue").mkpath
  end

  test do
    system bin/"rogue", "-s"
  end
end
