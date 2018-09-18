class SdlTtf < Formula
  desc "Library for using TrueType fonts in SDL applications"
  homepage "https://www.libsdl.org/projects/SDL_ttf/"
  url "https://www.libsdl.org/projects/SDL_ttf/release/SDL_ttf-2.0.11.tar.gz"
  sha256 "724cd895ecf4da319a3ef164892b72078bd92632a5d812111261cde248ebcdb7"
  revision 1

  bottle do
    cellar :any
    sha256 "09d3328d31341d4c76fa07e42480b283ee8f7ddb6518128e871debb84410521e" => :mojave
    sha256 "544d9fe4053cf2a83f9c34b91773518b8bffefeea6337f5d293f6064c3260972" => :high_sierra
    sha256 "22972859bc6ab2f2a6fd8a4cf5394e647336e4b83d982b02e7015ceb7799e59a" => :sierra
    sha256 "981960db1d2539b57bc42deb12ab59e163214d881612c1fffea72e4927e1c82a" => :el_capitan
    sha256 "cea0e7f2cb248778bc3af4cab3f3ddd7469d4b24d72780891d2cd54dbc9d7216" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "sdl"

  # Fix broken TTF_RenderGlyph_Shaded()
  # https://bugzilla.libsdl.org/show_bug.cgi?id=1433
  patch do
    url "https://gist.githubusercontent.com/tomyun/a8d2193b6e18218217c4/raw/8292c48e751c6a9939db89553d01445d801420dd/sdl_ttf-fix-1433.diff"
    sha256 "4c2e38bb764a23bc48ae917b3abf60afa0dc67f8700e7682901bf9b03c15be5f"
  end

  def install
    inreplace "SDL_ttf.pc.in", "@prefix@", HOMEBREW_PREFIX

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-sdltest"
    system "make", "install"
  end
end
