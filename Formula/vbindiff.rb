class Vbindiff < Formula
  desc "Visual Binary Diff"
  homepage "https://www.cjmweb.net/vbindiff/"
  url "https://www.cjmweb.net/vbindiff/vbindiff-3.0_beta5.tar.gz"
  sha256 "f04da97de993caf8b068dcb57f9de5a4e7e9641dc6c47f79b60b8138259133b8"

  bottle do
    cellar :any_skip_relocation
    sha256 "917deca949e3d585de8ef483a9318877b612eb6588a2e89b7095c6b0fd049c1f" => :high_sierra
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
