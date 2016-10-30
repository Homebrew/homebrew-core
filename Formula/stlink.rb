class Stlink < Formula
  desc "stm32 discovery line Linux programmer"
  homepage "https://github.com/texane/stlink"
  url "https://github.com/texane/stlink/archive/1.2.0.tar.gz"
  sha256 "acfdd52e350a61c14910f3c14b9ed232a79febcf35b38479b011d5cd2d4af688"

  head "https://github.com/texane/stlink.git"

  bottle do
    cellar :any
    sha256 "994705db9f6774bd689fc28e84ecab12314bff57f1b6f256139da4c2b8027964" => :sierra
    sha256 "66488952113480623d60375bbf01eca978fa9d090e6a9b359ecfdc49611753c3" => :el_capitan
    sha256 "8baf694edef81adcb72dcde439c376aa20e632b856278c7e490d1521fb7b52b2" => :yosemite
    sha256 "78d3598eb1de58654014bd48935f1c3ca1bc760f38d7d8165223054b9273f109" => :mavericks
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
