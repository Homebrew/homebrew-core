class X265 < Formula
  desc "H.265/HEVC encoder"
  homepage "https://bitbucket.org/multicoreware/x265_git"
  url "https://bitbucket.org/multicoreware/x265_git/downloads/x265_4.1.tar.gz"
  sha256 "a31699c6a89806b74b0151e5e6a7df65de4b49050482fe5ebf8a4379d7af8f29"
  license "GPL-2.0-only"
  head "https://bitbucket.org/multicoreware/x265_git.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b8a5e68579e954f4bfd2917891880f5861537f87c6787caaf72af7419747450f"
    sha256 cellar: :any,                 arm64_sonoma:  "b778a0d02445f7fdd4e638dc457540e7851be9a3a1662efcec5d031b59e43573"
    sha256 cellar: :any,                 arm64_ventura: "eaff65e197b22f708f4d44d12b9baf6ed8efeec1439460311ea3ba7722d8d2b3"
    sha256 cellar: :any,                 sonoma:        "103cc33efc4711d856fa765897140ca1348ebc82e8f8563c5fe3ad3eea3c6d4e"
    sha256 cellar: :any,                 ventura:       "a274accceee40a1139224b31963b31e15ee22eaab83dc76689035006aa995852"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "113a201d79f39fee805c280eba2dcc786f9153efaf71839ccc0c5d3a69592ce6"
  end

  depends_on "cmake" => :build

  on_intel do
    depends_on "nasm" => :build
  end

  def install
    ENV.runtime_cpu_detection
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
