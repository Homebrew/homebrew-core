class SourceHighlight < Formula
  desc "Source-code syntax highlighter"
  homepage "https://www.gnu.org/software/src-highlite/"
  url "https://ftpmirror.gnu.org/src-highlite/source-highlight-3.1.8.tar.gz"
  mirror "https://ftp.gnu.org/gnu/src-highlite/source-highlight-3.1.8.tar.gz"
  mirror "http://mirror.anl.gov/pub/gnu/src-highlite/source-highlight-3.1.8.tar.gz"
  sha256 "01336a7ea1d1ccc374201f7b81ffa94d0aecb33afc7d6903ebf9fbf33a55ada3"
  revision 3

  bottle do
    sha256 "e616cc32b0ef7272e3ec41f28a013f61d07f67b32ff4f2eced6d5fe9454f6098" => :sierra
    sha256 "d169803dc299be059cff022094d6a2a247f37f11d4c3b94ac12b191036192f13" => :el_capitan
    sha256 "285729a72e96e827367ae8746d6f56a8fdbcbd09d10118cab5f607ac4f947b80" => :yosemite
    sha256 "ddd81b0888585673246ca764061a8a712da48858144953e76f9a94486a8e2058" => :mavericks
  end

  depends_on "boost"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-boost=#{HOMEBREW_PREFIX}"
    system "make", "install"

    bash_completion.install "completion/source-highlight"
  end

  test do
    assert_match /GNU Source-highlight #{version}/, shell_output("#{bin}/source-highlight -V")
  end
end
