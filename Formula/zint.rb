class Zint < Formula
  desc "Barcode encoding library supporting over 50 symbologies"
  homepage "http://www.zint.org.uk/"
  url "https://downloads.sourceforge.net/project/zint/zint/2.9.1/zint-2.9.1-src.tar.gz"
  sha256 "bd286d863bc60d65a805ec3e46329c5273a13719724803b0ac02e5b5804c596a"
  license "GPL-3.0-or-later"
  head "https://git.code.sf.net/p/zint/code.git"

  livecheck do
    url :stable
    regex(%r{url=.*?/zint[._-]v?(\d+(?:\.\d+)+)(?:-src)?\.t}i)
  end

  bottle do
    cellar :any
    sha256 "3535dd6204bc2331673113f38ee7c213a8708a4958cbfca4bfe1cb074dd8eb2a" => :big_sur
    sha256 "047bb0ba1a7045832292a37e10e0fa68324081260e969928a5f4162ffc425f27" => :arm64_big_sur
    sha256 "27a13b9022616484c612860ec1ac80146f765de23c32a52cf7f6f7a516727672" => :catalina
    sha256 "398f6493010f6b4778fe5ce80b559b745f53de2dcbd0c331f844431274a1d1ac" => :mojave
    sha256 "7142283083b90b3d185672f98fc987292337b8cb50cfb4e76cb61394df05781a" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "libpng"

  def install
    # Sandbox fix: install FindZint.cmake in zint's prefix, not cmake's.
    inreplace "CMakeLists.txt", "${CMAKE_ROOT}", "#{share}/cmake"

    mkdir "zint-build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/zint", "-o", "test-zing.png", "-d", "This Text"
  end
end
