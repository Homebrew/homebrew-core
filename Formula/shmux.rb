class Shmux < Formula
  desc "Execute the same command on many hosts in parallel"
  homepage "https://github.com/shmux/shmux"
  url "https://github.com/shmux/shmux/archive/v1.0.2.tar.gz"
  sha256 "4b84dc3e0d72d054ed4730d130a509f43441fb61561c11a444d6ee65cbff9c04"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "c262e721176d0dfb35311492167e49151194467ad6ee99dec14cf519141c99e1" => :mojave
    sha256 "b9c8b089571c7ab0147c5f952822764e0671d9b142672fb1f59811ee8e8081e4" => :high_sierra
    sha256 "29fc7ae776f44efe3b1184bf32b60145e6369d63162183bd042e1bd65bc2b853" => :sierra
    sha256 "8686fcd4954ab4cd7cacbbf80306b355c0f0562d0b9917345e4e91396c891ee0" => :el_capitan
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/shmux", "-h"
  end
end
