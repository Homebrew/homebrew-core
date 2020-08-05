class Sxiv < Formula
  desc "Simple X Image Viewer"
  homepage "https://github.com/muennich/sxiv"
  url "https://github.com/muennich/sxiv/archive/v26.tar.gz"
  sha256 "a382ad57734243818e828ba161fc0357b48d8f3a7f8c29cac183492b46b58949"
  head "https://github.com/muennich/sxiv.git"

  bottle do
    cellar :any
    sha256 "76166fe7a568a675abf485137b4df514f4f0c187edc0502f298d0f482aa7ac80" => :catalina
    sha256 "1dc370bc45941faf5aeb36014160748df67446f4b51010c73a1ecc3851aed811" => :mojave
    sha256 "544f9660a23d0370a6cd3b5fe6ff207bf21a12dcac6aaea5dc35735b09fc258c" => :high_sierra
  end

  depends_on "giflib"
  depends_on "imlib2"
  depends_on "libexif"
  depends_on :x11

  def install
    system "make", "PREFIX=#{prefix}", "AUTORELOAD=nop",
                   "CPPFLAGS=-I/opt/X11/include", "LDFLAGS=-L/opt/X11/lib",
                   "LDLIBS=-lpthread", "install"
  end

  test do
    system "#{bin}/sxiv", "-v"
  end
end
