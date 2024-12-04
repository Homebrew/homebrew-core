class X265 < Formula
  desc "H.265/HEVC encoder"
  homepage "https://bitbucket.org/multicoreware/x265_git"
  url "https://bitbucket.org/multicoreware/x265_git/downloads/x265_4.1.tar.gz"
  sha256 "9217a4fcc795e3b57753be76c28bd3870afa96428955b4cd6bcdc1a17fe8844e"
  license "GPL-2.0-only"
  head "https://bitbucket.org/multicoreware/x265_git.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "64a91e7e9f9181a5c5c964f4b4e61cccadf12392544574ea75c1ad74c3b5a89f"
    sha256 cellar: :any,                 arm64_sonoma:  "2320907225bc99fd3167f1871af876630458ebbb4030a0706e12ba846c07b194"
    sha256 cellar: :any,                 arm64_ventura: "02dfe1f1d44105fbf40e26abc95b2528850e5d0c435fb3b89e13a1ca6c15b4b6"
    sha256 cellar: :any,                 sonoma:        "1bb7c6f5ea0defd63998ccd4b48a59afb98d711d81639f026fa8cc2a827a5daf"
    sha256 cellar: :any,                 ventura:       "5312e05c09c369b267d629220dfd0a71cd4eb53c2228d84dc41a9a13a1bbd6c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8c5bc441686cd06bf2ac1c1a740a58e7f1b40e0ee6b4c2b6b866ccef009f289"
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
