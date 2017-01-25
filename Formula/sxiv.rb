class Sxiv < Formula
  desc "Simple X Image Viewer"
  homepage "https://github.com/muennich/sxiv"
  url "https://github.com/muennich/sxiv/archive/v1.3.2.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/s/sxiv/sxiv_1.3.2.orig.tar.gz"
  sha256 "9f5368de8f0f57e78ebe02cb531a31107a993f2769cec51bcc8d70f5c668b653"

  head "https://github.com/muennich/sxiv.git"

  depends_on :x11
  depends_on "imlib2"
  depends_on "giflib"
  depends_on "libexif"

  def install
    system "make", "config.h"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system "#{bin}/sxiv", "-v"
  end
end
