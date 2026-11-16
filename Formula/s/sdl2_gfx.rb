class Sdl2Gfx < Formula
  desc "SDL2 graphics drawing primitives and other support functions"
  homepage "https://www.ferzkopp.net/wordpress/2016/01/02/sdl_gfx-sdl2_gfx/"
  url "https://www.ferzkopp.net/Software/SDL2_gfx/SDL2_gfx-1.1.0.tar.gz"
  mirror "https://downloads.sourceforge.net/project/sdl2gfx/SDL2_gfx-1.1.0.tar.gz"
  sha256 "9843924d46eacbabba685a239cf2284b948766a20ef2caa48cb18462a3295caf"
  license "Zlib"
  compatibility_version 1

  livecheck do
    url :homepage
    regex(/href=.*?SDL2_gfx[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "80639812b07f240ef48da0aaca069316b96b48e04cbf3c90b64a63f662d71285"
    sha256 cellar: :any, arm64_tahoe:       "a65576e4fdf58778efc41d07d7609983831ded53618fba9cfcdb9e4323781ab9"
    sha256 cellar: :any, arm64_sequoia:     "629f1fd2011ad495bc0ba4355ba87bb49f9847de49a9920c17b17da7041bbd72"
    sha256 cellar: :any, arm64_linux:       "742efb6e69f9d575e250b88cef8c9789f7207c2c99279e3977ecfb40db9cc032"
    sha256 cellar: :any, x86_64_linux:      "1ca71792c0fdfa294d6af652934e4f7e9ac61c3792070ca1d6354c3a6b5e9cb3"
  end

  depends_on "sdl2-compat"

  deny_network_access!

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
