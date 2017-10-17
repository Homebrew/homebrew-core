class SdlGfx < Formula
  desc "Graphics drawing primitives and other support functions"
  homepage "http://www.ferzkopp.net/joomla/content/view/19/14/"
  url "http://www.ferzkopp.net/Software/SDL_gfx-2.0/SDL_gfx-2.0.26.tar.gz"
  sha256 "7ceb4ffb6fc63ffba5f1290572db43d74386cd0781c123bc912da50d34945446"

  bottle do
    cellar :any
    sha256 "7602160fbf82f1572b598a73e9c2003bd5623c443ba150f59818013593833346" => :high_sierra
    sha256 "52829744591992f7c81ae5beb04f8be1a33229615425e4356ee3af863b9d2598" => :sierra
    sha256 "f14692eab7c7a7a60694ea6aca4094c6ceb869604f2c587dd044df880b3a747b" => :el_capitan
    sha256 "756fe923ceccdb3e9c5c7865298344a3520efe0bd549e493b109bc1506e6de29" => :yosemite
    sha256 "aa06ebfac9112febe86ec4a933d807ae88e87329498a71678bd52be51748d9dc" => :mavericks
  end

  depends_on "sdl"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-sdltest"
    system "make", "install"
  end
end
