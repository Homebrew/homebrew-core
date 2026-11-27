class SdlGfx < Formula
  desc "Graphics drawing primitives and other support functions"
  homepage "https://www.ferzkopp.net/wordpress/2016/01/02/sdl_gfx-sdl2_gfx/"
  url "https://github.com/ferzkopp/SDL_gfx/archive/refs/tags/v2.0.28.tar.gz"
  sha256 "7ed950ae0a5be3be1610bdecaba2fd71c8413927f10e4da267df6d75ea4b35c6"
  license "Zlib"

  livecheck do
    url :homepage
    regex(/href=.*?SDL_gfx[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    manifest_sha256 "d99d3ca204615012f5360271b746a0b47693a8749ca0633dc43d1d00476f8864"
    sha256 cellar: :any, arm64_golden_gate: "42799f9a6bf6e8b6306fec1994370277bde4a6829c436599b5dce2b4f4645654"
    sha256 cellar: :any, arm64_tahoe:       "0760b647e4267b19be015cfcd7a7e2e1d4dc8225e97e504dafd90f13bb1e9d1c"
    sha256 cellar: :any, arm64_sequoia:     "e7724fdbcf13b8ca715f9f405f9d9584c7a47894b4581dfcdbc53497816c6662"
    sha256 cellar: :any, arm64_linux:       "47c29bb910b43534a2b2ea9c4fdd0d31b068e6854f6ffa751c0cbf31ec6dd927"
    sha256 cellar: :any, x86_64_linux:      "af0e19ad8bdfc0f3049231aa929d85a22e95a744f0a4370f4b28e4452fc76ecd"
  end

  depends_on "cmake" => :build
  depends_on "sdl12-compat"

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <SDL/SDL_imageFilter.h>

      int main()
      {
        int mmx = SDL_imageFilterMMXdetect();
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lSDL_gfx", "-o", "test"
    system "./test"
  end
end
