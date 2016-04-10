class Zshdb < Formula
  desc "Debugger for zsh"
  homepage "https://github.com/rocky/zshdb"
  url "https://downloads.sourceforge.net/project/bashdb/zshdb/0.9/zshdb-0.09.tar.bz2"
  sha256 "3ad756485a5bfd014649f4ede15187d0cf070919d2ddb15b4ded61e8990e8d4f"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "4542047a09ea1d1d19cc4a5aecd29b8a56216bbb0c0fb1b5f18d4e469281edfa" => :el_capitan
    sha256 "7f327123ad69da56e966c329311f94aeb46725bdd69513eb819a81681ee22ec0" => :yosemite
    sha256 "3ad6c3dcefdf709effcc367353982383a1743d07a525970e3b36e0882bfbe645" => :mavericks
  end

  head do
    url "https://github.com/rocky/zshdb.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "zsh"

  def install
    system "./autogen.sh" if build.head?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-zsh=#{HOMEBREW_PREFIX}/bin/zsh"
    system "make", "install"
  end

  test do
    require "open3"
    Open3.popen3("#{bin}/zshdb -c 'echo test'") do |stdin, stdout, _|
      stdin.write "exit\n"
      assert_match(/That's all, folks/, stdout.read)
    end
  end
end
