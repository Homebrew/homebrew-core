class Sdl2Image < Formula
  desc "Library for loading images as SDL surfaces and textures"
  homepage "https://github.com/libsdl-org/SDL_image"
  url "https://github.com/libsdl-org/SDL_image/releases/download/release-2.6.2/SDL2_image-2.6.2.tar.gz"
  sha256 "48355fb4d8d00bac639cd1c4f4a7661c4afef2c212af60b340e06b7059814777"
  license "Zlib"

  # This formula uses a file from a GitHub release, so we check the latest
  # release version instead of Git tags.
  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/release[._-]v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c9fa27615fee118666ea9f72fbbd12dd56b834196fc097f81ee2fb3d6ac134f2"
    sha256 cellar: :any,                 arm64_monterey: "9957623300b351f7a5a8a9d5a53e23ab253f619e76f0ceda787ce9aa6e65bda7"
    sha256 cellar: :any,                 arm64_big_sur:  "62d71fe497de2509c66c439a42d9388d22838d17dd7e5c5b100ae056073cdb2a"
    sha256 cellar: :any,                 ventura:        "560c9818858ea121b28c813fb3cbe37f80c81b4b084e9250aa08f0318e094133"
    sha256 cellar: :any,                 monterey:       "85536b30fa7448b4144f04c17b5505f36ff2b41d68ff2c040131a21dbdc51b2e"
    sha256 cellar: :any,                 big_sur:        "660628e65267b3624a9337fb0828c2a6f56037b21d1da2910848be9ad58e2cbc"
    sha256 cellar: :any,                 catalina:       "40ed17b687354fabb22a87da5d995446088512a0293f3f867c48a74cea0d376d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e68e4f635af13f76c20dcfad45cc0037b5bd65bb55a9d83c613a4e6a5742ed34"
  end

  head do
    url "https://github.com/libsdl-org/SDL_image.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "sdl2"
  depends_on "webp"

  def install
    inreplace "SDL2_image.pc.in", "@prefix@", HOMEBREW_PREFIX

    system "./autogen.sh" if build.head?

    system "./configure", *std_configure_args,
                          "--disable-imageio",
                          "--disable-jpg-shared",
                          "--disable-png-shared",
                          "--disable-stb-image",
                          "--disable-tif-shared",
                          "--disable-webp-shared"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <SDL2/SDL_image.h>

      int main()
      {
          int success = IMG_Init(0);
          IMG_Quit();
          return success;
      }
    EOS
    system ENV.cc, "test.c", "-I#{Formula["sdl2"].opt_include}/SDL2", "-L#{lib}", "-lSDL2_image", "-o", "test"
    system "./test"
  end
end
