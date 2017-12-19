class SourceHighlight < Formula
  desc "Source-code syntax highlighter"
  homepage "https://www.gnu.org/software/src-highlite/"
  url "https://ftp.gnu.org/gnu/src-highlite/source-highlight-3.1.8.tar.gz"
  mirror "https://ftpmirror.gnu.org/src-highlite/source-highlight-3.1.8.tar.gz"
  mirror "https://fossies.org/linux/www/source-highlight-3.1.8.tar.gz"
  sha256 "01336a7ea1d1ccc374201f7b81ffa94d0aecb33afc7d6903ebf9fbf33a55ada3"
  revision 8

  bottle do
    sha256 "18982f120324ecc68e4a3ab7337b229114d911ee8399de1af60010149c62cea4" => :high_sierra
    sha256 "06761e3da2f94824ea6a70d52c798c764f80a1533058059a79ab31237b189240" => :sierra
    sha256 "a76ad2770fce66bc6f3ff67d037a79064aab6f0ef01e9da745623d2568d572e5" => :el_capitan
    sha256 "e485f2f17bbbc0c2a98677ce6f12da14ce8a29e5f667f5677686730a35573256" => :yosemite
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
