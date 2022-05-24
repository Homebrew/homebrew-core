class X265 < Formula
  desc "H.265/HEVC encoder"
  homepage "https://bitbucket.org/multicoreware/x265_git"
  url "https://bitbucket.org/multicoreware/x265_git/get/3.5.tar.gz"
  sha256 "5ca3403c08de4716719575ec56c686b1eb55b078c0fe50a064dcf1ac20af1618"
  license "GPL-2.0-only"
  head "https://bitbucket.org/multicoreware/x265_git.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "e60559191a9aba607e512ad33ac9f66688b12837df7e6a3cf57ceae26968235b"
    sha256 cellar: :any,                 arm64_big_sur:  "adc617eed2e065af669994fb5b538195fd46db4ac7b13c7ca2490dc8abaf6466"
    sha256 cellar: :any,                 monterey:       "be446f5c7cb4872205f260b8821fc7ebd5bd7c4b8837888c98c08e051dff2e3f"
    sha256 cellar: :any,                 big_sur:        "55bb46a5dc1924e59b7fa7bc800a21c0cf21355e48cb38b941d8e786427c70a0"
    sha256 cellar: :any,                 catalina:       "5e5bc106e1cf971a176dd5b37a61d28769e353f81102c011b4230cc8732eca7a"
    sha256 cellar: :any,                 mojave:         "c61ebdf9dcd4aedf5da2a7eb2b3a5154fd355c105a19a0471d43a3aa67f3cb88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c80f18988caea25e95ca87dd648f5ff8b0856e24d26adc8d68ca68cc6d4faabf"
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
    yuv_path = testpath/"raw.yuv"
    x265_path = testpath/"x265.265"
    yuv_path.binwrite "\xCO\xFF\xEE" * 3200
    system bin/"x265", "--input-res", "80x80", "--fps", "1", yuv_path, x265_path
    header = "AAAAAUABDAH//w=="
    assert_equal header.unpack("m"), [x265_path.read(10)]
  end
end
