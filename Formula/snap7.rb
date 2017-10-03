class Snap7 < Formula
  desc "Ethernet communication suite that works natively with Siemens S7 PLCs"
  homepage "https://snap7.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/snap7/1.4.2/snap7-full-1.4.2.7z"
  sha256 "1f4270cde8684957770a10a1d311c226e670d9589c69841a9012e818f7b9f80e"
  revision 1

  bottle do
    cellar :any
    sha256 "ed5bbb34831786cc62281716df93c5b1c15533793b49ec08efa85ffa1627c26c" => :sierra
    sha256 "a9067f22d44555dbe4cdf4a7d68d4f531a7120c2e1241535f4ad1610d5bbc5bc" => :el_capitan
    sha256 "53d421256ed6bb88628f05ad081e2829b27359707fe04b877aec10cd67ea18e4" => :yosemite
  end

  def install
    cd "snap7-full-#{version}"
    lib.mkpath
    system "make", "-C", "build/osx",
                   "-f", "#{MacOS.preferred_arch}_osx.mk",
                   "install", "LibInstall=#{lib}"
    include.install "release/Wrappers/c-cpp/snap7.h"
  end

  test do
    system "python", "-c", "import ctypes.util,sys;ctypes.util.find_library('snap7') or sys.exit(1)"
  end
end
