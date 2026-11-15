class Stlink < Formula
  desc "STM32 discovery line Linux programmer"
  homepage "https://github.com/stlink-org/stlink"
  url "https://github.com/stlink-org/stlink/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "10d6c3bff3d5a7f6aefd00e096339822cafc65acf32e43c842369e346d2e5069"
  license "BSD-3-Clause"
  head "https://github.com/stlink-org/stlink.git", branch: "testing"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ab7d64c9957c451a8b6883f3ce0b574580cc1acf15c969ca17f6031304771b29"
    sha256 cellar: :any, arm64_tahoe:       "0c7e6d248a855e8b2665b3b960d04f47b5eda457492b70f2f05660d047821810"
    sha256 cellar: :any, arm64_sequoia:     "be6827c8f82ac06d921aa3b140ab047303df80f741d71057b2417935ef840aab"
    sha256 cellar: :any, arm64_linux:       "ec0cdc190e4d23acb6349b17210b43de1e2f2fecacc15eb57aa9ab5e4c50a57c"
    sha256 cellar: :any, x86_64_linux:      "4ce8ab2a91f525c0afd85fb9d881fff7a5ee849d4f6fe0e12fbe536b1e756281"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libusb"

  deny_network_access!

  def install
    libusb = Formula["libusb"]
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DLIBUSB_INCLUDE_DIR=#{libusb.opt_include}/libusb-#{libusb.version.major_minor}
      -DLIBUSB_LIBRARY=#{libusb.opt_lib/shared_library("libusb-#{libusb.version.major_minor}")}
    ]
    if OS.linux?
      args << "-DSTLINK_MODPROBED_DIR=#{lib}/modprobe.d"
      args << "-DSTLINK_UDEV_RULES_DIR=#{lib}/udev/rules.d"
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    # Upstream also installs the shared library to bin, which is only needed for Windows DLLs
    rm(bin.glob("libstlink*"))
  end

  test do
    assert_match "st-flash #{version}", shell_output("#{bin}/st-flash --debug reset 2>&1", 255)
  end
end
