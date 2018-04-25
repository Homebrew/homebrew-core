class Sdl2Gfx < Formula
  desc "SDL2 graphics drawing primitives and other support functions"
  homepage "https://www.ferzkopp.net/wordpress/2016/01/02/sdl_gfx-sdl2_gfx/"
  url "https://www.ferzkopp.net/Software/SDL2_gfx/SDL2_gfx-1.0.4.tar.gz"
  sha256 "63e0e01addedc9df2f85b93a248f06e8a04affa014a835c2ea34bfe34e576262"

  bottle do
    cellar :any
    sha256 "fb9dcdd449ce4f71e30556975e193b6f2cd1e67488c631f648bd825c1fc09f97" => :high_sierra
    sha256 "5f65128809ec994585f79c338f1328d74ee7026ab15c3e2d5941aa4856f9b95b" => :sierra
    sha256 "b50afba34ca19059fc84e893738d449504d4b68fd130f155368b1d4d05d2233a" => :el_capitan
  end

  depends_on "sdl2"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-sdltest"
    system "make", "install"
  end
end
