class SdlGfx < Formula
  desc "Graphics drawing primitives and other support functions"
  homepage "https://www.ferzkopp.net/wordpress/2016/01/02/sdl_gfx-sdl2_gfx/"
  url "https://www.ferzkopp.net/Software/SDL_gfx-2.0/SDL_gfx-2.0.26.tar.gz"
  sha256 "7ceb4ffb6fc63ffba5f1290572db43d74386cd0781c123bc912da50d34945446"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?SDL_gfx[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "aec81e2bc74130659eed3f9e4f7b030cd71a6dc3d2296ee68b527279b23f64c7"
    sha256 cellar: :any,                 arm64_monterey: "af9f337edbb2f401a0505e72bc6f42e68d14e2ba64e5c2f469397af1a04ac8d3"
    sha256 cellar: :any,                 arm64_big_sur:  "b8f8c2beb411902ddb4f935e45d20fe2e36418ed590e2a8a909172a977b4faaf"
    sha256 cellar: :any,                 ventura:        "78b78399f6651bc01c795015168162cb7fdb293a12e0355d845133e300acdc0d"
    sha256 cellar: :any,                 monterey:       "c979523c308f31e6cf9c3f0013503a17b4b2e78a8349125e9a6a5009c56be1a1"
    sha256 cellar: :any,                 big_sur:        "7b7c585d3c2badbdcf28b7abc5d0edea49b09a2343ba0cb638d5bc985d3767df"
    sha256 cellar: :any,                 catalina:       "9f04e6070183366bf0c350c485641293b4fe5321a170e343e47df6118068675d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "815b0a03ae7ce77ab5f76417b7437d53527e4db708409fae9985b0cf0126d20a"
  end

  depends_on "sdl12-compat"

  def install
    extra_args = []
    extra_args << "--disable-mmx" if Hardware::CPU.arm?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-sdltest",
                          *extra_args
    system "make", "install"
  end
end
