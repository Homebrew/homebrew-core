class Taglib < Formula
  desc "Audio metadata library"
  homepage "https://taglib.org/"
  url "https://taglib.github.io/releases/taglib-1.13.tar.gz"
  sha256 "58f08b4db3dc31ed152c04896ee9172d22052bc7ef12888028c01d8b1d60ade0"
  license "LGPL-2.1"
  head "https://github.com/taglib/taglib.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "296ce5ae39a55c3fc0ea418c848949dafc688c54b9979175cf6a861e3ded3190"
    sha256 cellar: :any,                 arm64_monterey: "468e48c903a73adfdd4aed556791e20920ffced6148781e85ba17bed80276102"
    sha256 cellar: :any,                 arm64_big_sur:  "922c49278c55189998db81aa9f43e4a894c81d608824dd99231450ec6a657e1f"
    sha256 cellar: :any,                 ventura:        "6c6fb57e24337ce19713254391e91c5d3ce20d4b4c058ac2d55801fee52b0f80"
    sha256 cellar: :any,                 monterey:       "e7324317ad232da4eccfb794cbf7d29fe105116932200b26ee1dfd1915eba6db"
    sha256 cellar: :any,                 big_sur:        "456c785f52b5d19c621495e31fe4dde36168f6ef5b0ef377d866ba1867000c78"
    sha256 cellar: :any,                 catalina:       "9a828d637c0f66c3ab0c5180b897e34d37ad671bcf1447d8b3c76436967a8b0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72b61dd6278d2efbbfe344821c77907b39d8454349b371d4898443b1037e79fb"
  end

  depends_on "cmake" => :build

  uses_from_macos "zlib"

  def install
    system "cmake", "-DWITH_MP4=ON", "-DWITH_ASF=ON", "-DBUILD_SHARED_LIBS=ON",
                    *std_cmake_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/taglib-config --version")
  end
end
