class X265 < Formula
  desc "H.265/HEVC encoder"
  homepage "https://bitbucket.org/multicoreware/x265_git"
  url "https://bitbucket.org/multicoreware/x265_git/get/3.5.tar.gz"
  sha256 "5ca3403c08de4716719575ec56c686b1eb55b078c0fe50a064dcf1ac20af1618"
  license "GPL-2.0-only"
  head "https://bitbucket.org/multicoreware/x265_git.git"

  bottle do
    sha256 arm64_big_sur: "a9fbfb88baa295ff5a3d2d91e474a47a8c129f7b7ec6730e7e6259b64cdd96fa"
    sha256 big_sur:       "991122bf5989da02883fdecb41630187e53bba6d8a8d8745a1173bf18c041542"
    sha256 catalina:      "8dd7f134ee375d2f6d0020e63e2455a38a2c235fb738c232189cef5d214724f7"
    sha256 mojave:        "45a71f2c56450a494f8f1c89f321670d61e8189da9bff60fbb9334c34c45380e"
  end

  depends_on "cmake" => :build
  depends_on "nasm" => :build if Hardware::CPU.intel?

  def install
    # Build based off the script at ./build/linux/multilib.sh
    args = std_cmake_args + %W[
      -DLINKED_10BIT=ON
      -DLINKED_12BIT=ON
      -DEXTRA_LINK_FLAGS=-L.
      -DEXTRA_LIB=x265_main10.a;x265_main12.a
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    high_bit_depth_args = std_cmake_args + %w[
      -DHIGH_BIT_DEPTH=ON -DEXPORT_C_API=OFF
      -DENABLE_SHARED=OFF -DENABLE_CLI=OFF
    ]
    (buildpath/"8bit").mkpath

    mkdir "10bit" do
      system "cmake", buildpath/"source", "-DENABLE_HDR10_PLUS=ON", *high_bit_depth_args
      system "make"
      mv "libx265.a", buildpath/"8bit/libx265_main10.a"
    end

    mkdir "12bit" do
      system "cmake", buildpath/"source", "-DMAIN12=ON", *high_bit_depth_args
      system "make"
      mv "libx265.a", buildpath/"8bit/libx265_main12.a"
    end

    cd "8bit" do
      system "cmake", buildpath/"source", *args
      system "make"
      mv "libx265.a", "libx265_main.a"

      on_macos do
        system "libtool", "-static", "-o", "libx265.a", "libx265_main.a",
                          "libx265_main10.a", "libx265_main12.a"
      end

      on_linux do
        system "ar", "cr", "libx265.a", "libx265_main.a", "libx265_main10.a",
                           "libx265_main12.a"
        system "ranlib", "libx265.a"
      end

      system "make", "install"
    end
  end

  test do
    yuv_path = testpath/"raw.yuv"
    x265_path = testpath/"x265.265"
    yuv_path.binwrite "\xCO\xFF\xEE" * 3200
    system bin/"x265", "--input-res", "80x80", "--fps", "1", yuv_path, x265_path
    header = "AAAAAUABDAH//w=="
    assert_equal header.unpack("m"), [x265_path.read(10)]
  end
end
