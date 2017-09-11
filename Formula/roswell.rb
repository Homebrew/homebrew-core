class Roswell < Formula
  desc "Lisp installer and launcher for major environments"
  homepage "https://github.com/roswell/roswell"
  url "https://github.com/roswell/roswell/archive/v17.9.10.82.tar.gz"
  sha256 "d9a99996af2e8f0ab0fd7dc7181a391cc07d5f6e731d32baa4eaa49c26397d5c"
  head "https://github.com/roswell/roswell.git"

  bottle do
    sha256 "41b61980452451eb221e8f627bd37b812502c4c9c8de981c4b9bd9e65c02a525" => :sierra
    sha256 "6599f5069b073f29849005147d3a91203d78bdce403b43232c128ff3ca995b1e" => :el_capitan
  end

  depends_on "automake" => :build
  depends_on "autoconf" => :build

  def install
    system "./bootstrap"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--enable-manual-generation",
                          "--enable-html-generation",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    ENV["ROSWELL_HOME"] = testpath
    system bin/"ros", "init"
    assert_predicate testpath/"config", :exist?
  end
end
