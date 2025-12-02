class Zix < Formula
  desc "C99 portability and data structure library"
  homepage "https://gitlab.com/drobilla/zix"
  url "https://gitlab.com/drobilla/zix/-/archive/v0.8.0/zix-v0.8.0.tar.gz"
  sha256 "51d70d63e970214db84e32d55377d84090c02145f5768265ab140d117f2b8e24"
  license "ISC"
  head "https://gitlab.com/drobilla/zix.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a2caa9a4a3c1d808886349f7e83a4faf142e9bd013b881047ecfcee1ce5b6338"
    sha256 cellar: :any,                 arm64_sequoia: "c5af8595950f1294f8cec733c452c09742721ec154477103b3e4ad0270afa20e"
    sha256 cellar: :any,                 arm64_sonoma:  "601886f43ccadbd571d61385ae8487f5bf40563cb1e2aec7b3925d0eb52ed6c6"
    sha256 cellar: :any,                 sonoma:        "0d3ee7b239f61e53be24ca66fc61b1fa51e64709e855c705e4013c96c46b7e76"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "abb43fca2d5a4418b636b99560f30e051b1d83f57c16b2a171b5d4e9590624fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94d2a4ebb9e9d5f9a1bd1d991ed5da942df3630636b45b5c31db7537bc811e1c"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "glib"

  def install
    args = %w[
      -Dbenchmarks=disabled
      -Dtests=disabled
    ]
    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include "zix/attributes.h"
      #include "zix/string_view.h"

      #if defined(__GNUC__)
      #  pragma GCC diagnostic push
      #  pragma GCC diagnostic ignored "-Wunused-variable"
      #endif

      static void
      string_views(void)
      {
        const char* const string_pointer = "some string";

        // begin make-empty-string
        ZixStringView empty = zix_empty_string();
        // end make-empty-string

        // begin make-static-string
        static const ZixStringView hello = ZIX_STATIC_STRING("hello");
        // end make-static-string
        (void)hello;

        // begin measure-string
        ZixStringView view = zix_string(string_pointer);
        // end measure-string

        // begin make-string-view
        ZixStringView slice = zix_substring(string_pointer, 4);
        // end make-string-view
      }

      ZIX_CONST_FUNC
      int
      main(void)
      {
        string_views();
        return 0;
      }

      #if defined(__GNUC__)
      #  pragma GCC diagnostic pop
      #endif
    C
    system ENV.cc, "test.c", "-I#{include}/zix-0", "-o", "test"
    system "./test"
  end
end
