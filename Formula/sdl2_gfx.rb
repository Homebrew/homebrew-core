class Sdl2Gfx < Formula
  desc "SDL2 graphics drawing primitives and other support functions"
  homepage "http://cms.ferzkopp.net/index.php/software/13-sdl-gfx"
  url "https://www.ferzkopp.net/Software/SDL2_gfx/SDL2_gfx-1.0.3.tar.gz"
  sha256 "a4066bd467c96469935a4b1fe472893393e7d74e45f95d59f69726784befd8f8"

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
