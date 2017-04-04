class Sxiv < Formula
  desc "Simple X Image Viewer"
  homepage "https://github.com/muennich/sxiv"
  url "https://github.com/muennich/sxiv/archive/v1.3.2.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/s/sxiv/sxiv_1.3.2.orig.tar.gz"
  sha256 "9f5368de8f0f57e78ebe02cb531a31107a993f2769cec51bcc8d70f5c668b653"
  revision 1

  head "https://github.com/muennich/sxiv.git"

  bottle do
    cellar :any
    sha256 "e5bcdb136a9ffc360193193461e64502369bd5f8a083525a273cca35bf49e0f8" => :sierra
    sha256 "39d8e6f5f08b72e8e7d48681d7d44d7f56a52ee36f9c8b836e825e09a769e0c5" => :el_capitan
    sha256 "0ef89ec26f91d1639744ecb5ceec0db81d675e8a1ce6c7946f4a46488842e49a" => :yosemite
  end

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
