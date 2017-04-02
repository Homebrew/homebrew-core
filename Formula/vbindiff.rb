class Vbindiff < Formula
  desc "Visual Binary Diff"
  homepage "https://www.cjmweb.net/vbindiff/"
  url "https://www.cjmweb.net/vbindiff/vbindiff-3.0_beta4.tar.gz"
  version "3.0_beta4"
  sha256 "7d5d5a87fde953dc2089746f6f6ab811d60e127b01074c97611898fb1ef1983d"

  bottle do
    cellar :any_skip_relocation
    sha256 "6afdf87c94325cb9a0907bfda78033c28e2c3973a6cc564d0159ff6237f609c7" => :sierra
    sha256 "73f69ac6f7cea7a406c3bf755b9780d7cd87cc46f2916b8224a34e521af6f58c" => :el_capitan
    sha256 "e9eaffa8b280ec31a05a937f3bb6ec4921e96a8655172c5f282ead0a97f806ce" => :yosemite
    sha256 "fbdb102612ca9137b4c89b3dcfa3e624fd5e4bacdd0783f763a35cb050615f02" => :mavericks
    sha256 "e231beebaf188fa8188b0f5372643b7127acfbf3f105a7ed56f0b40d5f6b15d0" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/vbindiff", "-L"
  end
end
