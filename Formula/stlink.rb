class Stlink < Formula
  desc "STM32 discovery line Linux programmer"
  homepage "https://github.com/texane/stlink"
  url "https://github.com/texane/stlink/archive/v1.6.0.tar.gz"
  sha256 "5575e9322e6914fad3bcbcad77fa2669e4b1853cd49bed44bfac1c68992f538a"
  head "https://github.com/texane/stlink.git"

  bottle do
    cellar :any
    sha256 "37847a2056adeb51918e7f660a92c6d13e8959e7527de2f9988c8b3c247c4e3f" => :catalina
    sha256 "afafd4057259f0971e38fc899b86d2543e216e011a384d16396fcdc1126277a3" => :mojave
    sha256 "626bf84c5d2a98f0824b1d2da49047f8587d949b4fe26ad02c0d3211509bbf2b" => :high_sierra
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
