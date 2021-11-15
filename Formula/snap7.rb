class Snap7 < Formula
  desc "Ethernet communication suite that works natively with Siemens S7 PLCs"
  homepage "https://snap7.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/snap7/1.4.2/snap7-full-1.4.2.7z"
  sha256 "1f4270cde8684957770a10a1d311c226e670d9589c69841a9012e818f7b9f80e"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any, monterey:    "0e80fc31c025dc39b1b551adb4328023a0b9f99643d8e246ab644529b9b7e3e1"
    sha256 cellar: :any, big_sur:     "52d04e1646b47ba15e5877e8c24b8f2d0267a51d8b7b07ee47330ecd2c44d95a"
    sha256 cellar: :any, catalina:    "015a23b1cb6728a86716811511e51fba427c69febabd1af5507af31d77523802"
    sha256 cellar: :any, mojave:      "71aff7cbb3e78369d6b9a93887820dd7def1afe382ed82211be313942e1bb81d"
    sha256 cellar: :any, high_sierra: "b0d670ce6a2d780d13cfaa3346c6aa701f280a85be010dc42c802d6ebd028694"
    sha256 cellar: :any, sierra:      "e04dea88411f3b444dcab340d3f11bd739fb853de65701e727546a9481981924"
  end

  def install
    lib.mkpath
    system "make", "-C", "build/osx",
                   "-f", "x86_64_osx.mk",
                   "install", "LibInstall=#{lib}"
    include.install "release/Wrappers/c-cpp/snap7.h"
  end

  test do
    system "python", "-c", "import ctypes.util,sys;ctypes.util.find_library('snap7') or sys.exit(1)"
  end
end
