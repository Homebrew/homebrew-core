class SourceHighlight < Formula
  desc "Source-code syntax highlighter"
  homepage "https://www.gnu.org/software/src-highlite/"
  url "https://ftp.gnu.org/gnu/src-highlite/source-highlight-3.1.9.tar.gz"
  mirror "https://ftpmirror.gnu.org/src-highlite/source-highlight-3.1.9.tar.gz"
  sha256 "3a7fd28378cb5416f8de2c9e77196ec915145d44e30ff4e0ee8beb3fe6211c91"
  revision 1

  bottle do
    sha256 "fac19971a1a63d2b16842157b4941e61d73a46318633ce185b2ed71df9a5db09" => :catalina
    sha256 "4459bbef81e9a9d8872bd4ef9ebf5d70620f2723956ae028ce5542288793f753" => :mojave
    sha256 "0ea7ec70be5c0e02a211f7079afd181568f2085c0982b1d4bf7a27ceac8f2347" => :high_sierra
  end

  depends_on "boost"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-boost=#{Formula["boost"].opt_prefix}"
    system "make", "install"

    bash_completion.install "completion/source-highlight"
  end

  test do
    assert_match /GNU Source-highlight #{version}/, shell_output("#{bin}/source-highlight -V")
  end
end
