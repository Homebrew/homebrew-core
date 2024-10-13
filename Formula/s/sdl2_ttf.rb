class Sdl2Ttf < Formula
  desc "Library for using TrueType fonts in SDL applications"
  homepage "https://github.com/libsdl-org/SDL_ttf"
  url "https://github.com/libsdl-org/SDL_ttf/releases/download/release-2.22.0/SDL2_ttf-2.22.0.tar.gz"
  sha256 "d48cbd1ce475b9e178206bf3b72d56b66d84d44f64ac05803328396234d67723"
  license "Zlib"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "d39aae740c3fecc2329784ee379b5faaebb2ae9977ac43e827aeb767a26f15da"
    sha256 cellar: :any,                 arm64_sonoma:   "244dc789ae5618ab35e6ff0508b9fb5a298e777ca5a41cbd41dc00846ab3a900"
    sha256 cellar: :any,                 arm64_ventura:  "51fc93a32a3ae58c3467186c977782f6aee043dcfec5990311393ce78fdd293c"
    sha256 cellar: :any,                 arm64_monterey: "7000ed898fccf6f0ce7dd6ef383a5e389edb37cef5284156eb165dfc21d8339e"
    sha256 cellar: :any,                 sonoma:         "a84ed76722bda781c2ea2a978d6ddf8d895752e45b9dfaf9a0988d5c3e3755e8"
    sha256 cellar: :any,                 ventura:        "8f40d557b225e0fdd5ce0a80e9fb97fbf68ac1f147f38ea333b83e651cb80e81"
    sha256 cellar: :any,                 monterey:       "f06a7a2c359bf6a8eb4668e06b6d92374b72f3c3b0a0cc9e9fb97c11acfae87b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60ca48a32fed27ead81ba32acc20e755e6e35dd5e4ef984eacb0319ea4381cf2"
  end

  head do
    url "https://github.com/libsdl-org/SDL_ttf.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "harfbuzz"
  depends_on "sdl2"

  def install
    inreplace "SDL2_ttf.pc.in", "@prefix@", HOMEBREW_PREFIX

    system "./autogen.sh" if build.head?

    # `--enable-harfbuzz` is the default, but we pass it
    # explicitly to generate an error when it isn't found.
    system "./configure", "--disable-freetype-builtin",
                          "--disable-harfbuzz-builtin",
                          "--enable-harfbuzz",
                          *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <SDL2/SDL_ttf.h>

      int main()
      {
          int success = TTF_Init();
          TTF_Quit();
          return success;
      }
    EOS
    system ENV.cc, "test.c", "-I#{Formula["sdl2"].opt_include}/SDL2", "-L#{lib}", "-lSDL2_ttf", "-o", "test"
    system "./test"
  end
end
