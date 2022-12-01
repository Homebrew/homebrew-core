class SvtAv1 < Formula
  desc "AV1 encoder"
  homepage "https://gitlab.com/AOMediaCodec/SVT-AV1"
  url "https://gitlab.com/AOMediaCodec/SVT-AV1/-/archive/v1.4.0/SVT-AV1-v1.4.0.tar.bz2"
  sha256 "d236457eb0b839716b3609db2ce6db62c103a1ca0e9e2eed0239e194b72bdcd0"
  license "BSD-3-Clause"
  head "https://gitlab.com/AOMediaCodec/SVT-AV1.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d7a9df8e0ff19e369b6616c12119d9aca9a6582af11dbca64c2ae39eb8ece137"
    sha256 cellar: :any,                 arm64_monterey: "84e557b94d5ba4fe6ae3afae4bdb271b86386c54c86d83eca4e6294e61fa18f2"
    sha256 cellar: :any,                 arm64_big_sur:  "5bca5860ba31ce2c9235febd699f3b65ab8dd40f8781b04b641d8294e07ba002"
    sha256 cellar: :any,                 ventura:        "40daa52c355271b6021ef0e93a8ba8b2a9426e90b4add44b4bd49c4afdd0f2db"
    sha256 cellar: :any,                 monterey:       "57aaf6debc48668cf445fcdd9df23d7b6be98754b5dd47b8890848bf3bc54ff3"
    sha256 cellar: :any,                 big_sur:        "855688c54dbabc9ea9364ffbabd0cdb1e419a53c613835ce391fb0a2efcd983f"
    sha256 cellar: :any,                 catalina:       "a6f81e578b515c4a8467adfa7705a2a0551002025f84a6c5f79a9ce81d4cca37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48b23231c32b44cb3969a5dfb97b649162477b729174f718d9a87882da7acf74"
  end

  depends_on "cmake" => :build

  on_intel do
    depends_on "yasm" => :build
  end

  resource "homebrew-testvideo" do
    url "https://github.com/grusell/svt-av1-homebrew-testdata/raw/main/video_64x64_yuv420p_25frames.yuv"
    sha256 "0c5cc90b079d0d9c1ded1376357d23a9782a704a83e01731f50ccd162e246492"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    testpath.install resource("homebrew-testvideo")
    system "#{bin}/SvtAv1EncApp", "-w", "64", "-h", "64", "-i", "video_64x64_yuv420p_25frames.yuv", "-b", "output.ivf"
    assert_predicate testpath/"output.ivf", :exist?
  end
end
