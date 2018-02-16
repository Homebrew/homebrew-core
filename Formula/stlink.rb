class Stlink < Formula
  desc "STM32 discovery line Linux programmer"
  homepage "https://github.com/texane/stlink"
  url "https://github.com/texane/stlink/archive/1.5.0.tar.gz"
  sha256 "ce26b3db73f0bdf87ced78a2a90f3d515914f7d1211b1ca4b9acdf1882ca9d81"

  head "https://github.com/texane/stlink.git"

  bottle do
    cellar :any
    sha256 "1c00964c08eeb84ec190481201ecc7470f673fc42f1fda818490dc418c930fa8" => :high_sierra
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
