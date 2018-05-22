class X265 < Formula
  desc "H.265/HEVC encoder"
  homepage "http://x265.org"
  url "https://bitbucket.org/multicoreware/x265/downloads/x265_2.8.tar.gz"
  sha256 "6e59f9afc0c2b87a46f98e33b5159d56ffb3558a49d8e3d79cb7fdc6b7aaa863"
  head "https://bitbucket.org/multicoreware/x265", :using => :hg

  bottle do
    cellar :any
    sha256 "f3709d31e52cc5e59e691223a73655fce69ae43ec65e28e23928cdcb2d898edf" => :high_sierra
    sha256 "dd3ec00052e814d7a70b82c96d1584f8003de61334c5adbba0b039c4322450a4" => :sierra
    sha256 "bc6020d1f762de347021220798afd04e8bbe2cf438e78a0c4aeaa133e71a06da" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "nasm" => :build
  depends_on :macos => :lion

  def install
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
