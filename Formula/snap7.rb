class Snap7 < Formula
  desc "Ethernet communication suite that works natively with Siemens S7 PLCs"
  homepage "http://snap7.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/snap7/1.4.2/snap7-full-1.4.2.7z"
  sha256 "65af129e11de4b0d942751bcd9c563f7012cae174931860c03dbb2cdf2e80ae7"

  bottle do
    cellar :any
    sha256 "b31ea99a516376e68a5b610d72bf5fc7af72b3030d5a8c45efd3bf472c42b154" => :sierra
    sha256 "c65d8e3e9f9f1a426ed4b7581fdf44afa45da09e4dc0f70669d3c72288a96fe1" => :el_capitan
    sha256 "b8fa94cae36795dc754f17123317bd2e816f99907cecd2522e587ec52cbdb453" => :yosemite
    sha256 "d152d00966b20ae4429b3aabe53e91635bf2ee6125cae563778aefade1e59d0e" => :mavericks
    sha256 "ea1eeaee1876b4ef948cdef5b5f9b9a9b8233d93ffe285ad13fe1301100ca318" => :mountain_lion
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
