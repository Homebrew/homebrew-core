class Snap7 < Formula
  desc "Ethernet communication suite that works natively with Siemens S7 PLCs"
  homepage "https://snap7.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/snap7/1.4.2/snap7-full-1.4.2.7z"
  sha256 "1f4270cde8684957770a10a1d311c226e670d9589c69841a9012e818f7b9f80e"
  revision 1

  bottle do
    cellar :any
    sha256 "5540f68aadc159b4a590079b1b4f06b042438f0f714456af3f5dfbfc34af47ac" => :high_sierra
    sha256 "edd667d4018983951999c21da14d1929b95a9dba2a908c88e721ad7febc2fa5d" => :sierra
    sha256 "45c77c8c6862e3c2b0840c3a32d23a95d53d73b7b35960f747a380bc5563d00e" => :el_capitan
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
