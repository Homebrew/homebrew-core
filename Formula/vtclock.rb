class Vtclock < Formula
  desc "Text-mode fullscreen digital clock"
  homepage "https://webonastick.com/vtclock/"
  url "https://webonastick.com/vtclock/vtclock-2005-02-20.tar.gz"
  version "2005-02-20"
  sha256 "5fcbceff1cba40c57213fa5853c4574895755608eaf7248b6cc2f061133dab68"

  bottle do
    cellar :any_skip_relocation
    sha256 "766e69763326b8a8c5cfdc636cbba9f6fcffde0739be56612c54a2904d95d456" => :sierra
    sha256 "f87c685e59533a0085b439c4153c2734d4091447f5a81c627ccc0d2e589ac65d" => :el_capitan
    sha256 "a72a8c176276c40a3e9b0c6083a61013efb55b5ea43cd786000dad3c4243dd96" => :yosemite
    sha256 "9811bd8bb3e5cd2f94dc37346e09588bbab5cb1f0cb1ef5f094adf20046440da" => :mavericks
  end

  def install
    system "make"
    bin.install "vtclock"
  end

  test do
    system "#{bin}/vtclock", "-h"
  end
end
