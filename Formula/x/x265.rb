class X265 < Formula
  desc "H.265/HEVC encoder"
  homepage "https://bitbucket.org/multicoreware/x265_git"
  url "https://bitbucket.org/multicoreware/x265_git/downloads/x265_4.2.tar.gz"
  sha256 "40b1ea0453e0309f0eba934e0ddf533f8f6295966679e8894e8f1c1c8d5e1210"
  license "GPL-2.0-or-later"
  compatibility_version 1
  head "https://bitbucket.org/multicoreware/x265_git.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ee3075f8af9807bdb30a890b22c1e948a5930f6001c7123eb57faa87c4d15c85"
    sha256 cellar: :any,                 arm64_sequoia: "29300af7c34c7bc5fd84549b2e0173909026c264060d56bf6d35d79da3808506"
    sha256 cellar: :any,                 arm64_sonoma:  "614fd3ece81d8eaf67d18d2a8fb5d8d04f8004982547bbdaa1743bf621b1bc7e"
    sha256 cellar: :any,                 sonoma:        "661c9c3a348ce2c6677204fa20bc7751bd5c6e32cffac91b41a01194257ba35d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1cd1acdf8fe735cd2ca65e7f480ff487166aa6c73038fc14d9487e0ece0d597e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "828f429ad04ef1e539d1539de78b84e3c10c295edee9b512ba64e8d029abf0d1"
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
