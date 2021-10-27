class SdlTtf < Formula
  desc "Library for using TrueType fonts in SDL applications"
  homepage "https://www.libsdl.org/projects/SDL_ttf/release-1.2.html"
  revision 1

  stable do
    url "https://www.libsdl.org/projects/SDL_ttf/release/SDL_ttf-2.0.11.tar.gz"
    sha256 "724cd895ecf4da319a3ef164892b72078bd92632a5d812111261cde248ebcdb7"

    # Fix broken TTF_RenderGlyph_Shaded()
    # https://bugzilla.libsdl.org/show_bug.cgi?id=1433
    patch do
      url "https://gist.githubusercontent.com/tomyun/a8d2193b6e18218217c4/raw/8292c48e751c6a9939db89553d01445d801420dd/sdl_ttf-fix-1433.diff"
      sha256 "4c2e38bb764a23bc48ae917b3abf60afa0dc67f8700e7682901bf9b03c15be5f"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "319307cfab828ba53251e7693cd7f4b8e7e4838a5e725209b5f408274d3fea22"
    sha256 cellar: :any,                 arm64_big_sur:  "5e82bcaa6cc1cb3ec449c957678e71f23681f7bc998e16b3f39dd39baf5cd8ad"
    sha256 cellar: :any,                 monterey:       "c79683000aa4798c66ef61b9ea172a17538fed6df09ca54381cc83d7f73f0827"
    sha256 cellar: :any,                 big_sur:        "6fa67e2282123689e1391faec02d41a1cda527f9cb0b89f9c0e4bd0dd7ee5407"
    sha256 cellar: :any,                 catalina:       "66d8be19ddde69b3b260b50e23a4a9f63d22c3343f3d2be530a062b6e00bf690"
    sha256 cellar: :any,                 mojave:         "09d3328d31341d4c76fa07e42480b283ee8f7ddb6518128e871debb84410521e"
    sha256 cellar: :any,                 high_sierra:    "544d9fe4053cf2a83f9c34b91773518b8bffefeea6337f5d293f6064c3260972"
    sha256 cellar: :any,                 sierra:         "22972859bc6ab2f2a6fd8a4cf5394e647336e4b83d982b02e7015ceb7799e59a"
    sha256 cellar: :any,                 el_capitan:     "981960db1d2539b57bc42deb12ab59e163214d881612c1fffea72e4927e1c82a"
    sha256 cellar: :any,                 yosemite:       "cea0e7f2cb248778bc3af4cab3f3ddd7469d4b24d72780891d2cd54dbc9d7216"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67b8e8037a2275859bd2925311ec215319e34b1f002e5f273c6a32b571460f3a"
  end

  head do
    url "https://github.com/libsdl-org/SDL_ttf.git", branch: "SDL-1.2"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  # SDL 1.2 is deprecated, unsupported, and not recommended for new projects.
  deprecate! date: "2013-08-17", because: :deprecated_upstream

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "sdl"

  def install
    inreplace "SDL_ttf.pc.in", "@prefix@", HOMEBREW_PREFIX

    system "./autogen.sh" if build.head?

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-sdltest"
    system "make", "install"
  end
end
