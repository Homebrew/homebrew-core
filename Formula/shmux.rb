class Shmux < Formula
  desc "Execute the same command on many hosts in parallel"
  homepage "http://web.taranis.org/shmux/"
  url "http://web.taranis.org/shmux/dist/shmux-1.0.2.tgz"
  sha256 "0886aaca4936926d526988d85df403fa1679a60c355f1be8432bb4bc1e36580f"

  bottle do
    cellar :any_skip_relocation
    sha256 "4567e06552f5e4f489f7d5de2814c83ba4a82b8d9bbbcba266fab5bd1f1ded71" => :sierra
    sha256 "87424e1fd8b33691a0b87b35deb8c74a09308264bf8da87a933880491a62cd78" => :el_capitan
    sha256 "c12d7d72b94ac69fe7fa5db7247228a555c2071cce5ebb84c7bc9046fef55bb4" => :yosemite
    sha256 "88a7a017cc820f2508bb12796dbfd84f35f3c1b6a64a1867e7e89861b2420418" => :mavericks
    sha256 "27099056d50aa5f23d9e4dbb1307abf2dbecea031c2af5b085229e3d063dff4c" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/shmux", "-h"
  end
end
