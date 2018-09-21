class Stlink < Formula
  desc "STM32 discovery line Linux programmer"
  homepage "https://github.com/texane/stlink"
  url "https://github.com/texane/stlink/archive/v1.5.1.tar.gz"
  sha256 "e0145fbfd3e781f21baf12a0750b0933c445ee6338e36142836bf5a2c267e107"
  head "https://github.com/texane/stlink.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "65d735edcaf4fbc2d23d564a831309d43bedc1efaa9574b0e697f48256711df2" => :mojave
    sha256 "9640919d8abfe07ea06e0c208d13dba96988a99bf8ae6080afcc4c332f58b530" => :high_sierra
    sha256 "9662ae4fc8ff28f24ea2441a9629fbc66732f1c24d9bd71fca94cea4d16a5901" => :sierra
    sha256 "f74ea6ea462e6c7de089bcdcb92f9b44f1e9809e8989da7cc50a65ade4e1be77" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libusb"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system bin/"st-util", "-h"
  end
end
