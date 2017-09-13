class Stlink < Formula
  desc "STM32 discovery line Linux programmer"
  homepage "https://github.com/texane/stlink"
  url "https://github.com/texane/stlink/archive/1.4.0.tar.gz"
  sha256 "d99b8385cce8071d5e58de21b6c8866058af20a8dd46ecf01e1c1dc3aa038cc9"

  head "https://github.com/texane/stlink.git"

  bottle do
    cellar :any
    sha256 "1f90c0e23af7e9cfb12a14e895093a1b9ffe119a07e5a5fe5111b720ae6d7c2f" => :sierra
    sha256 "4a5c0b1d04d0d410ff99829d71fc2e7832b586e82cd29c731f2093cefa213e57" => :el_capitan
    sha256 "88f7976a27b805d2481c9a3cadc391ed3aa0124cedd52f72feecb8e3e09e6c88" => :yosemite
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
