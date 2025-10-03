class Vvenc < Formula
  desc "Fraunhofer Versatile Video Encoder"
  homepage "https://github.com/fraunhoferhhi/vvenc"
  url "https://github.com/fraunhoferhhi/vvenc/archive/refs/tags/v1.13.1.tar.gz"
  sha256 "9d0d88319b9c200ebf428471a3f042ea7dcd868e8be096c66e19120a671a0bc8"
  license "BSD-3-Clause-Clear"
  head "https://github.com/fraunhoferhhi/vvenc.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6ff2a0e57323213b64e43a108807eeb2500624452b0ab087fd38619374146ca8"
    sha256 cellar: :any,                 arm64_sequoia: "2e526df41954df8bd763675725849ffc2567bf9f44133309939d0d6623e0bb98"
    sha256 cellar: :any,                 arm64_sonoma:  "df6e45adb580246422f6bf5d0a9e366633e5238011b30e18c25794018b24fc66"
    sha256 cellar: :any,                 arm64_ventura: "2ae0e24d7f2d84238c98bf7f57fca61652348b3e915195d7bbb30cd2cdee4c43"
    sha256 cellar: :any,                 sonoma:        "9e14a23f8a69305779d246ff1c1401250d07d5599419e034dd136421510501d6"
    sha256 cellar: :any,                 ventura:       "16c29cb6a182e02a04594cf43dd9c72e21dbf2c1e2061443ebdd3d19b01615fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0621f4273cc43a0320e06a61647300c4a05fc14c2e75e3c8a1919b312d675c5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8bff00818fee11e6b176f71b084247d14b41f1bc2e4920a2cff1acc50faa9d2c"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
           "-DVVENC_INSTALL_FULLFEATURE_APP=1",
           "-DBUILD_SHARED_LIBS=1",
           *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource "homebrew-test_video" do
      url "https://raw.githubusercontent.com/fraunhoferhhi/vvenc/master/test/data/RTn23_80x44p15_f15.yuv"
      sha256 "ecd2ef466dd2975f4facc889e0ca128a6bea6645df61493a96d8e7763b6f3ae9"
    end

    resource("homebrew-test_video").stage testpath
    system bin/"vvencapp",
           "-i", testpath/"RTn23_80x44p15_f15.yuv",
           "-s", "360x640",
           "--fps", "60/1",
           "--format", "yuv420_10",
           "--hdr", "hdr10_2020",
           "-o", testpath/"RTn23_80x44p15_f15.vvc"
    assert_path_exists testpath/"RTn23_80x44p15_f15.vvc"
  end
end
