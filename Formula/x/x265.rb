class X265 < Formula
  desc "H.265/HEVC encoder"
  homepage "https://github.com/Multicorewareinc/x265"
  url "https://github.com/Multicorewareinc/x265/releases/download/4.3/x265_4.3.tar.gz"
  sha256 "83c53e4c8bbb8f1e33ed59e10a7d621d1d7801ca853910c3eb41f038b8ffb121"
  license "GPL-2.0-or-later"
  compatibility_version 2
  head "https://github.com/Multicorewareinc/x265.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "844a99704d4b41e0b33331b795d3a0bba7756001f68c1925dc3dea88d5aa3a18"
    sha256 cellar: :any, arm64_sequoia: "d7a29d4ca9769865867553e82966934fa9bc28c82e28a5b3c7a58aab1b198aed"
    sha256 cellar: :any, arm64_sonoma:  "43a69b4518ba9d8d805293f004eda174e755e82da2281d647a328e9e1958a188"
    sha256 cellar: :any, sonoma:        "4897c4847fd853aa6504f46afeeed3ede5be35f3e81c77085ce1c637a6864bc3"
    sha256 cellar: :any, arm64_linux:   "6453c51228d07d5dc9df25f958b72a3e661bde039165e61cc52c3059bdeeb637"
    sha256 cellar: :any, x86_64_linux:  "2a9573f55f4c30c18fcd56604e255f8b2c26528ac3de08e015b6469503ebd637"
  end

  depends_on "cmake" => :build

  on_intel do
    depends_on "nasm" => :build
  end

  def install
    ENV.runtime_cpu_detection
    # Build based off the script at ./build/linux/multilib.sh
    args = %W[
      -DLINKED_10BIT=ON
      -DLINKED_12BIT=ON
      -DEXTRA_LINK_FLAGS=-L.
      -DEXTRA_LIB=x265_main10.a;x265_main12.a
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    args << "-DENABLE_SVE2=OFF" if OS.linux? && Hardware::CPU.arm?
    high_bit_depth_args = %w[
      -DHIGH_BIT_DEPTH=ON -DEXPORT_C_API=OFF
      -DENABLE_SHARED=OFF -DENABLE_CLI=OFF
    ]
    high_bit_depth_args << "-DENABLE_SVE2=OFF" if OS.linux? && Hardware::CPU.arm?

    (buildpath/"8bit").mkpath
    system "cmake", "-S", buildpath/"source", "-B", "10bit",
                    "-DENABLE_HDR10_PLUS=ON",
                    *high_bit_depth_args,
                    *std_cmake_args
    system "cmake", "--build", "10bit"
    mv "10bit/libx265.a", buildpath/"8bit/libx265_main10.a"

    system "cmake", "-S", buildpath/"source", "-B", "12bit",
                    "-DMAIN12=ON",
                    *high_bit_depth_args,
                    *std_cmake_args
    system "cmake", "--build", "12bit"
    mv "12bit/libx265.a", buildpath/"8bit/libx265_main12.a"

    system "cmake", "-S", buildpath/"source", "-B", "8bit", *args, *std_cmake_args
    system "cmake", "--build", "8bit"

    cd "8bit" do
      mv "libx265.a", "libx265_main.a"

      if OS.mac?
        system "libtool", "-static", "-o", "libx265.a", "libx265_main.a",
                          "libx265_main10.a", "libx265_main12.a"
      else
        system "ar", "cr", "libx265.a", "libx265_main.a", "libx265_main10.a",
                           "libx265_main12.a"
        system "ranlib", "libx265.a"
      end

      system "make", "install"
    end
  end

  test do
    resource "homebrew-test_video" do
      url "https://raw.githubusercontent.com/fraunhoferhhi/vvenc/master/test/data/RTn23_80x44p15_f15.yuv"
      sha256 "ecd2ef466dd2975f4facc889e0ca128a6bea6645df61493a96d8e7763b6f3ae9"
    end

    resource("homebrew-test_video").stage testpath
    yuv_path = testpath/"RTn23_80x44p15_f15.yuv"
    x265_path = testpath/"x265.265"
    system bin/"x265", "--input-res", "360x640", "--fps", "60", "--input", yuv_path, "-o", x265_path
    header = "AAAAAUABDAH//w=="
    assert_equal header.unpack("m"), [x265_path.read(10)]

    assert_match "version #{version}", shell_output("#{bin}/x265 -V 2>&1")
  end
end
