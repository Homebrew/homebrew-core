class Stklos < Formula
  desc "Scheme system compliant with the features defined in R5RS"
  homepage "http://www.stklos.net/"
  url "http://www.stklos.net/download/stklos-1.10.tar.gz"
  sha256 "215e6e6ffcf7751be5f0c114f83286f99e556e089ca1b0ee66f54dd1be080de4"

  bottle do
    sha256 "4d97cc4abd2792a8d07bb092359c35e168619bc446d289faafc37e74de9af8e4" => :sierra
    sha256 "4cded14db644fa6b3efa95af862bcb10a928d16168afb85fc592209bfcd1ba9c" => :el_capitan
    sha256 "a47d7c08a0f93c492e836dbcb825b699d7e725bf98bb49c28f88a8a80b432b37" => :yosemite
    sha256 "487ea0c067d772458cb7fd51cf34335938337832151d401298fe0d7916fe1bd5" => :mavericks
    sha256 "7684bf3baa91152729fcd9909c6a0425f80aff212dd86f0393a98781b188afb4" => :mountain_lion
  end

  depends_on "gmp"
  depends_on "pcre"
  depends_on "bdw-gc"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "42", shell_output("stklos -e '(print (+ 41 1))'").chomp
  end
end
