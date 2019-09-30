class SdlGfx < Formula
  desc "Graphics drawing primitives and other support functions"
  homepage "https://www.ferzkopp.net/joomla/content/view/19/14/"
  url "https://www.ferzkopp.net/Software/SDL_gfx-2.0/SDL_gfx-2.0.26.tar.gz"
  sha256 "7ceb4ffb6fc63ffba5f1290572db43d74386cd0781c123bc912da50d34945446"

  bottle do
    cellar :any
    sha256 "f06bf72be3f614ed944157f9e3fc0a13395ca4136eed4e1400762d791c576ad2" => :catalina
    sha256 "4a25e0639ae3c4e687bb8f9d6af00be3baf270565cd0402f7aa3af2a94e349d1" => :mojave
    sha256 "b1040e970fe68325a37c4a6af037206c28d12ae77f49851a0d28333e7c19a5e4" => :high_sierra
    sha256 "643210ccd7a2d9f2fc92d519900bbeb51c1f168729e40860c40e67629ce2ef8a" => :sierra
    sha256 "072983d26bc7e50acd12ef27adab047c3e14e45dff83e98be9ea005c7c107524" => :el_capitan
  end

  depends_on "sdl"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-sdltest"
    system "make", "install"
  end
end
