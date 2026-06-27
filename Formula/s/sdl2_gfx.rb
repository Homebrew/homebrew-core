class Sdl2Gfx < Formula
  desc "SDL2 graphics drawing primitives and other support functions"
  homepage "https://www.ferzkopp.net/wordpress/2016/01/02/sdl_gfx-sdl2_gfx/"
  url "https://www.ferzkopp.net/Software/SDL2_gfx/SDL2_gfx-1.0.4.tar.gz"
  mirror "https://sources.voidlinux.org/SDL2_gfx-1.0.4/SDL2_gfx-1.0.4.tar.gz"
  sha256 "63e0e01addedc9df2f85b93a248f06e8a04affa014a835c2ea34bfe34e576262"
  license "Zlib"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?SDL2_gfx[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "656d8e9d2503d3e176165c70e240c4acd3d8fb6d8845a5da300439c9c4c92990"
    sha256 cellar: :any, arm64_sequoia: "4495c158a58866ad66a946ba06222a9041a1b670dc255c62cae1a6251981e87c"
    sha256 cellar: :any, arm64_sonoma:  "726280db5aa92a0ace6d293c1b6b807ee6eb34fd76665208d85b562445dff99b"
    sha256 cellar: :any, sonoma:        "8efc5bff6b68d8598d6097bd16f62360452415d294a22c30f81132c4a0f64480"
    sha256 cellar: :any, arm64_linux:   "d6c4321fa7c217877cad6c6815f5bc671b5fd3f390aef62061018f03dfbbbab3"
    sha256 cellar: :any, x86_64_linux:  "63a286ac8e097c5048702a8b88c70a04f33148e0d98e1ba9aeb52a631538e53c"
  end

  depends_on "sdl2-compat"

  def install
    args = []
    args << "--disable-mmx" if Hardware::CPU.arm?

    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm64?

    # Workaround to avoid undefined references with `sdl2-compat`.
    # Not actively maintained with last activity in 2018
    ENV.append "LIBS", "-lm" if OS.linux?

    system "./configure", "--disable-sdltest", *args, *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <SDL2/SDL2_imageFilter.h>

      int main()
      {
        int mmx = SDL_imageFilterMMXdetect();
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lSDL2_gfx", "-o", "test"
    system "./test"
  end
end
