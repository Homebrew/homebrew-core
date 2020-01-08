class Xpa < Formula
  desc "Seamless communication between Unix programs"
  homepage "https://hea-www.harvard.edu/RD/xpa/"
  url "https://github.com/ericmandel/xpa/archive/v2.1.19.tar.gz"
  sha256 "44f1059009a7afe12029b808212393e352b3fa61701615350752ecf6c802ea48"

  bottle do
    cellar :any_skip_relocation
    sha256 "bb91619a16950257bd0d38e4a31efb591d28f49d7f8abaa258f2320b85f66839" => :catalina
    sha256 "5472c2f6a21a42fef5af1719fcc7948277950e740c6dbabf0046218748c63387" => :mojave
    sha256 "c0dc2dc017c17f0add29646c011602af1ce4ac208cf03b80674f2fa480f89ac9" => :high_sierra
    sha256 "40cf0e2dc27c94926ab77537d28efad269499956a08b8a7792c05958adfe77b0" => :sierra
  end

  depends_on :x11

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"

    # relocate man, since --mandir is ignored
    mv "#{prefix}/man", man
  end
end
