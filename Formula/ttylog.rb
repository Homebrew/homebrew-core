class Ttylog < Formula
  desc "Serial port logger: print everything from a serial device"
  homepage "http://ttylog.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ttylog/ttylog/0.25/ttylog-0.25.tar.gz"
  sha256 "80d0134ae4e29b650fff661169a6e667d22338465720ee768b2776f68aac8614"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "14f6db9530f81f45f45c9347b9de949438b0f2d789a1a1da02717eabf3861d92" => :sierra
    sha256 "b29b2a11f90578f51027ec61d698e47945815c8c4442f3b3094d2791d3a20961" => :el_capitan
    sha256 "e366c88f54d1c419aeb6b7382ddefd5ff1e796bb8d2aed7b993f7c914a053f12" => :yosemite
    sha256 "52bae78a4d014b5a4f22b1b1d3e6e767e97d1954ade3b79e50d420569b6ded1e" => :mavericks
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"

      bin.install sbin/"ttylog"
    end
  end

  test do
    system "#{bin}/ttylog", "-h"
  end
end
