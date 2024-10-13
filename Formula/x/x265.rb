class X265 < Formula
  desc "H.265/HEVC encoder"
  homepage "https://bitbucket.org/multicoreware/x265_git"
  url "https://bitbucket.org/multicoreware/x265_git/get/3.6.tar.gz"
  sha256 "206329b9599c78d06969a1b7b7bb939f7c99a459ab283b2e93f76854bd34ca7b"
  license "GPL-2.0-only"
  head "https://bitbucket.org/multicoreware/x265_git.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "9d5cc2819d36a019616fe084fc842a57bd169de59c1df477e5dabe376e702f78"
    sha256 cellar: :any,                 arm64_sonoma:   "ab1b8982179412855def72a0bff980132f6540c6f068070b1c6b90734ddc9357"
    sha256 cellar: :any,                 arm64_ventura:  "e8edbb9ad48bd30b4ccb2f7c00910bb70350d494821e91afe964fe2cd4ffa14c"
    sha256 cellar: :any,                 arm64_monterey: "fd6642c6d2cc8d79d681ab0fc0653b809d121f9c86480841b3e747cd2a4d89d2"
    sha256 cellar: :any,                 sonoma:         "58e2a262d8b390c5a1c61cbfb0b13e8444f9b7f238df45de743345f1cb74c950"
    sha256 cellar: :any,                 ventura:        "f490eb7249f069ed6eca04205ac8807d8cbd27aa33399a0e5b00789abcb59d2c"
    sha256 cellar: :any,                 monterey:       "8824a782a3c8a6f7b319751292ff3a9074e02ba6e54b4e80fec01fdb6aff254c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d876f2d12e9eaff8c98a01af67852e864e75fc9f6a1f818164c7b1d8d6688dc"
  end

  depends_on "cmake" => :build

  on_intel do
    depends_on "nasm" => :build
  end

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
