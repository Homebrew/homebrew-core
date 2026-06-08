class Uavs3d < Formula
  desc "AVS3 decoder which supports AVS3-P2 baseline profile."
  homepage "https://github.com/uavs3/uavs3d"
  license "BSD-3-Clause"
  head "https://github.com/uavs3/uavs3d.git"
  version "1.2_1"

  depends_on "cmake" => :build
  depends_on "gawk" => :build

  def install
    system "cmake", "-DCOMPILE_10BIT=1", "-S", ".", "-B", "build", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    system "false"
  end
end
