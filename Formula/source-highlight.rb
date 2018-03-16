class SourceHighlight < Formula
  desc "Source-code syntax highlighter"
  homepage "https://www.gnu.org/software/src-highlite/"
  url "https://ftp.gnu.org/gnu/src-highlite/source-highlight-3.1.8.tar.gz"
  mirror "https://ftpmirror.gnu.org/src-highlite/source-highlight-3.1.8.tar.gz"
  mirror "https://fossies.org/linux/www/source-highlight-3.1.8.tar.gz"
  sha256 "01336a7ea1d1ccc374201f7b81ffa94d0aecb33afc7d6903ebf9fbf33a55ada3"
  revision 8

  bottle do
    sha256 "3101cb3776039eba399f7a9d42cbd68120abaa2c3fd02401bd43128020bdf22c" => :high_sierra
    sha256 "c8f9401b678b754e82d3cd7a78f6e7c164a1ece1832ca73ac77f11023de87de9" => :sierra
    sha256 "d8f960586c5a0b5249ceacbe3996042fdfbce29a50c3adc65087e02f3daf361b" => :el_capitan
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
