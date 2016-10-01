class SdlNet < Formula
  desc "Sample cross-platform networking library"
  homepage "https://www.libsdl.org/projects/SDL_net/release-1.2.html"
  url "https://www.libsdl.org/projects/SDL_net/release/SDL_net-1.2.8.tar.gz"
  sha256 "5f4a7a8bb884f793c278ac3f3713be41980c5eedccecff0260411347714facb4"

  bottle do
    cellar :any
    sha256 "65cc3ae3104620de06f03ca0d9b3a545d90f2a36955dcb528f5f42af6db11bcf" => :sierra
    sha256 "036938975b4060fdc944c2258a8d1d5d73f536860a9c807116e6c4fb2aa65dc8" => :el_capitan
    sha256 "fe6b8eda1d640db450ed12f79feb731d49a62263c4b83601d69659498d697538" => :yosemite
    sha256 "99f9035f95e548ea81eb11ac9c06ae5eab8d2797ea9ca03ac074fe30bb357748" => :mavericks
  end

  option :universal

  depends_on "pkg-config" => :build
  depends_on "sdl"

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--disable-sdltest"
    system "make", "install"
  end
end
