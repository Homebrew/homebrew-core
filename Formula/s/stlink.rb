class Stlink < Formula
  desc "STM32 discovery line Linux programmer"
  homepage "https://github.com/stlink-org/stlink"
  license "BSD-3-Clause"

  stable do
    url "https://github.com/stlink-org/stlink/archive/refs/tags/v1.8.0.tar.gz"
    sha256 "cff760b5c212c2cc480f705b9ca7f3828d6b9c267950c6a547002cd0a1f5f6ac"

    # upstream PR ref, https://github.com/stlink-org/stlink/pull/1373
    patch do
      url "https://github.com/stlink-org/stlink/commit/4eafbb29d106b32221c8d3b375b31d78f07de182.patch?full_index=1"
      sha256 "a745b3f10eb9c831838afc53e94038f61b29cdbe70970d3417d15f0db5301791"
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "a1318d007d2ebd3a5efac196e4c2be465b0bb7a4f6b7b937211d17ad447d983e"
    sha256 arm64_sequoia: "74429f7151b0a5f5ec7e8f150dadcaad6fc89c8c100edbada6360195e257322c"
    sha256 arm64_sonoma:  "f446d762cfa087474e6c4110af9cfd1764501715b1f6e6c67e73f66950a4ab08"
    sha256 sonoma:        "535d44df1d077f72e893542b763d70fd8cb527dd23801e9bea188146f2f4b7e8"
    sha256 arm64_linux:   "3acecdba1528f1b3be80a7323eee6810539ef12e53943db52ee2806354e9d4a8"
    sha256 x86_64_linux:  "08e0054f6e1ecf8c7298ca5938e79b3d9533d2ddbcc90585adf1303bf2ef0423"
  end

  head do
    url "https://github.com/stlink-org/stlink.git", branch: "develop"

    # same libusb-related patch as stable, should be removed on next release, since they will sync again
    patch do
      url "https://github.com/stlink-org/stlink/commit/45f1c2ca0032afdbb6b71e1e93527310ae429b0e.patch?full_index=1"
      sha256 "810d99f9411837754d9ec9f76ba576e1404b65d94fa98f7a24b09e5f5a914907"
    end
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libusb"

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
