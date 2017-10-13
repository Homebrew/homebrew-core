class Roswell < Formula
  desc "Lisp installer and launcher for major environments"
  homepage "https://github.com/roswell/roswell"
  url "https://github.com/roswell/roswell/archive/v17.10.10.83.tar.gz"
  sha256 "c837475a4e2ee27d2ad323b1f37ebc915f2977f92a91f8f6cbbfd432e8c55703"
  head "https://github.com/roswell/roswell.git"

  bottle do
    sha256 "8fe12251f886d2ad37bdce877767cb762b1ac953e6d5c7565a4cb9e544001a38" => :high_sierra
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
