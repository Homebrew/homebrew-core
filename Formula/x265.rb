class X265 < Formula
  desc "H.265/HEVC encoder"
  homepage "https://bitbucket.org/multicoreware/x265"
  url "https://bitbucket.org/multicoreware/x265/downloads/x265_3.2.tar.gz"
  sha256 "364d79bcd56116a9e070fdeb1d9d2aaef1a786b4970163fb56ff0991a183133b"
  head "https://bitbucket.org/multicoreware/x265", :using => :hg

  bottle do
    cellar :any
    rebuild 1
    sha256 "40073f7e35946c170761119b575e6bea2dbbb943ccf94290398c38f411732964" => :catalina
    sha256 "df084126a3bbf8e57bad448c7a975644f1dee08482c216c8bef3f05a0354ed91" => :mojave
    sha256 "4a66e49d1df591f27e2bfa50ecb6c378a53e87b892af1bfabab9fe476ad2159b" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "nasm" => :build

  def install
    # Work around Xcode 11 clang bug
    # https://bitbucket.org/multicoreware/x265/issues/514/wrong-code-generated-on-macos-1015
    ENV.append_to_cflags "-fno-stack-check" if DevelopmentTools.clang_build_version >= 1010

    # Build based off the script at ./build/linux/multilib.sh
    args = std_cmake_args + %w[
      -DLINKED_10BIT=ON
      -DLINKED_12BIT=ON
      -DEXTRA_LINK_FLAGS=-L.
      -DEXTRA_LIB=x265_main10.a;x265_main12.a
    ]
    high_bit_depth_args = std_cmake_args + %w[
      -DHIGH_BIT_DEPTH=ON -DEXPORT_C_API=OFF
      -DENABLE_SHARED=OFF -DENABLE_CLI=OFF
    ]
    (buildpath/"8bit").mkpath

    mkdir "10bit" do
      system "cmake", buildpath/"source", *high_bit_depth_args
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
      system "libtool", "-static", "-o", "libx265.a", "libx265_main.a",
                        "libx265_main10.a", "libx265_main12.a"
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
