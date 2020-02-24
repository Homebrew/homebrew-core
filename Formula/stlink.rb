class Stlink < Formula
  desc "STM32 discovery line Linux programmer"
  homepage "https://github.com/texane/stlink"
  url "https://github.com/texane/stlink/archive/v1.6.0.tar.gz"
  sha256 "5575e9322e6914fad3bcbcad77fa2669e4b1853cd49bed44bfac1c68992f538a"
  head "https://github.com/texane/stlink.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "71586a0e11d540bc26627bb0300df6a4a02e2dc95b5e81d19aa4a73514f88f40" => :catalina
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
    assert_match "st-flash #{version}", shell_output("#{bin}/st-flash --debug reset 2>&1", 255)
  end
end
