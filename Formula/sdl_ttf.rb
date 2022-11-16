class SdlTtf < Formula
  desc "Library for using TrueType fonts in SDL applications"
  homepage "https://www.libsdl.org/projects/SDL_ttf/release-1.2.html"
  revision 2

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
    sha256 cellar: :any,                 arm64_ventura:  "92fc8bfc2e879eab0c05baac2a75e8423c10a14ba7488a33a6c66c27d9520143"
    sha256 cellar: :any,                 arm64_monterey: "0e89bd1b3868b572e95b2d3419132baf15d21e28a7580df1eba477a031774267"
    sha256 cellar: :any,                 arm64_big_sur:  "1e70767306907c70b57d7cffe00526f1f006db2590422dc4d68f92ff1a355838"
    sha256 cellar: :any,                 ventura:        "5660876344b81ae6e0d816f353a358e58980efb8649e3e72e0c13e0ba8a8b91d"
    sha256 cellar: :any,                 monterey:       "f8515e231b0fd3df331de4e008b01eea709ce67b87d3cdf7e484646be2b0c204"
    sha256 cellar: :any,                 big_sur:        "ac7b776e96763c6f354d8e37dcc885f80d75b8f728e47dda197990c16c43417d"
    sha256 cellar: :any,                 catalina:       "23c1366db18218ce07c7307125b491c847c9507890f7cdaaa4fedd0c1facce08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf482059e92304181eb73757f15c8652cc567124aef46d7e11893e9eec218113"
  end

  head do
    url "https://github.com/libsdl-org/SDL_ttf.git", branch: "SDL-1.2"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  # SDL 1.2 is deprecated, unsupported, and not recommended for new projects.
  # Commented out while this formula still has dependents.
  # deprecate! date: "2013-08-17", because: :deprecated_upstream

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "sdl12-compat"

  def install
    ENV.append "LDFLAGS", "-liconv" if OS.mac?
    inreplace "SDL_ttf.pc.in", "@prefix@", HOMEBREW_PREFIX

    system "./autogen.sh" if build.head?
    system "./configure", *std_configure_args, "--disable-sdltest"
    system "make", "install"
  end
end
