class Stlink < Formula
  desc "STM32 discovery line Linux programmer"
  homepage "https://github.com/stlink-org/stlink"
  url "https://github.com/stlink-org/stlink/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "cff760b5c212c2cc480f705b9ca7f3828d6b9c267950c6a547002cd0a1f5f6ac"
  license "BSD-3-Clause"
  head "https://github.com/stlink-org/stlink.git", branch: "develop"

  bottle do
    sha256 arm64_sequoia:  "234d04d230556d8342bc80d9d8564e7c643f86ebd39c8e3d9cd10667076c4459"
    sha256 arm64_sonoma:   "182146c51940a4851235c5a1e66e0a1455d5833a112537c366b68314f4280d62"
    sha256 arm64_ventura:  "11f6ede1d7a55e0ceb814ea59df7e88560f317fd9ed9d1bf47c9905bb1b28b68"
    sha256 arm64_monterey: "5aec98fdb4a07aa5abfd1292ec15bf9c385869845fc107c905f35baf2c21bb75"
    sha256 sonoma:         "123d84cd6f2bdeeabce247febb96aed963876789e3e23bec7312098b2590483c"
    sha256 ventura:        "96b6ee1f313c0b377a3882eb33191164b751f171dd1ba2c6c9e8ef525b663798"
    sha256 monterey:       "5c33e3d172d272295fa0d27e08d80fd86e0429156e44b72b934898c11d08ab11"
    sha256 arm64_linux:    "4b0deecf90ccc793307fb68a4b72e13a7cd8eebf05012ad6d26fd4f2adfa80e7"
    sha256 x86_64_linux:   "7872c14d351e27c5953bc0565d4eb64312d3e54abc898b05197af8a631abab2c"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libusb"

  # upstream PR ref, https://github.com/stlink-org/stlink/pull/1373
  patch do
    url "https://github.com/stlink-org/stlink/commit/4eafbb29d106b32221c8d3b375b31d78f07de182.patch?full_index=1"
    sha256 "a745b3f10eb9c831838afc53e94038f61b29cdbe70970d3417d15f0db5301791"
  end
  patch do
    url "https://github.com/stlink-org/stlink/commit/d742e752d896c0f8d4a61b282457401f7a681b16.patch?full_index=1"
    sha256 "1f86ccdcb6bbf2d8cf53d6c96e76c1f11aef83c9de0e8dbe9b8d5cafab02c28d"
  end

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
  end

  test do
    assert_match "st-flash #{version}", shell_output("#{bin}/st-flash --debug reset 2>&1", 255)
  end
end
