class Xpa < Formula
  desc "Seamless communication between Unix programs"
  homepage "http://hea-www.harvard.edu/RD/xpa/"
  url "https://github.com/ericmandel/xpa/archive/v2.1.18.tar.gz"
  sha256 "a8c9055b913204babce2de4fa037bc3a5849941dcb888f57368fd04af0aa787b"

  depends_on :x11

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"

    # relocate man, since --mandir is ignored
    mv "#{prefix}/man", man
  end

  test do
    system "#{bin}/xpa", "--version"
  end
end
