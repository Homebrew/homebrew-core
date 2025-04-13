class Zix < Formula
  desc "C99 portability and data structure library"
  homepage "https://gitlab.com/drobilla/zix"
  url "https://gitlab.com/drobilla/zix/-/archive/v0.6.2/zix-v0.6.2.tar.gz"
  sha256 "caa1435c870767e12f71454e8b17e878fa9b4bb35730b8f570934fb7cb74031c"
  license "ISC"
  head "https://gitlab.com/drobilla/zix.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c6efcf45aaec03ed33102d16b0c877c274e1161fbd1e506ab031543aec03a8f2"
    sha256 cellar: :any,                 arm64_sonoma:  "cfd378e7408c1888de5bd8212e1d0e89a59cb44de25d4c783e75d311bbbc8f3b"
    sha256 cellar: :any,                 arm64_ventura: "b8c3832ec02675aab399184719cee2875f180499de50384dd22b49a725458e28"
    sha256 cellar: :any,                 sonoma:        "36f4526e82d1f62246b84b8237752be4d9931cc2490704b8a99cd88fe47fd487"
    sha256 cellar: :any,                 ventura:       "8150b763b4d195e8f6a891ec43780af77851c7c7abd516b856177570323452ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aeae53fce7afe265ce9ea5a32dfe62f64c937e534273f6cb6b6d199a490b47df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d635d3fd06b65cff8b6d49c9a78e33b214937b63c4a0c43b0df6ace47e2ecedd"
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
