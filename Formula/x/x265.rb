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
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f0248b90a5003c97961b15e862a94ba591e8a41d7e5ceec88dd0f82e3802b3d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "113a201d79f39fee805c280eba2dcc786f9153efaf71839ccc0c5d3a69592ce6"
  end

  depends_on "cmake" => :build

  on_intel do
    depends_on "nasm" => :build
  end

  # cmake 4 workaround, remove in next release
  patch do
    url "https://bitbucket.org/multicoreware/x265_git/commits/b354c009a60bcd6d7fc04014e200a1ee9c45c167/raw"
    sha256 "cc24fae87d3af05af3a5ab57041cabc4fb4dc93a6d575d69dd23831fe0856204"
  end
  patch do
    url "https://bitbucket.org/multicoreware/x265_git/commits/51ae8e922bcc4586ad4710812072289af91492a8/raw"
    sha256 "4ee41ef60ce1f992b4d23f2f76e2113fb8eac936429d4905507370d345a403bd"
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
    args << "-DCMAKE_POLICY_VERSION_MINIMUM=3.5" # FIXME: Workaround for CMake 4.
    high_bit_depth_args = %w[
      -DHIGH_BIT_DEPTH=ON -DEXPORT_C_API=OFF
      -DENABLE_SHARED=OFF -DENABLE_CLI=OFF
    ]
    high_bit_depth_args << "-DENABLE_SVE2=OFF" if OS.linux? && Hardware::CPU.arm?
    high_bit_depth_args << "-DCMAKE_POLICY_VERSION_MINIMUM=3.5" # FIXME: Workaround for CMake 4.

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
