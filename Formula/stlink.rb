class Stlink < Formula
  desc "STM32 discovery line Linux programmer"
  homepage "https://github.com/texane/stlink"
  url "https://github.com/texane/stlink/archive/1.5.0.tar.gz"
  sha256 "ce26b3db73f0bdf87ced78a2a90f3d515914f7d1211b1ca4b9acdf1882ca9d81"

  head "https://github.com/texane/stlink.git"

  bottle do
    cellar :any
    sha256 "4315b392911292547e652ef382b6fd26f6d37522997e9be560c5a08808b116ac" => :high_sierra
    sha256 "33f865238b5f5e3a994a180aa0a580f8faf05c6dda43eac1e52a522091526fdf" => :sierra
    sha256 "ccbaf675310990051e49e0aa53e29f64c54fa9dee4b9d80dd414af0a94aa7694" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libusb"
  depends_on "gtk+3" => :optional

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system bin/"st-util", "-h"
  end
end
