class Stlink < Formula
  desc "stm32 discovery line Linux programmer"
  homepage "https://github.com/texane/stlink"
  url "https://github.com/texane/stlink/archive/1.3.0.tar.gz"
  sha256 "3e8cba21744d2c38a0557f6835a05189e1b98202931bb0183d22efc462c893dd"

  head "https://github.com/texane/stlink.git"

  bottle do
    cellar :any
    sha256 "cc01774bc5230a56e043b04ec6ed7a1eea36210195b0f1202e69fe337ac6d223" => :sierra
    sha256 "f58b526c119d7d37bfb6917bf8f37cc4a49d0a6e3158e5810c61d3e8135b47bb" => :el_capitan
    sha256 "d3b0bf7c2945ab9d8d86f296c21a6eea6cb5e2cbe90d9ac83521012154b64a4e" => :yosemite
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
