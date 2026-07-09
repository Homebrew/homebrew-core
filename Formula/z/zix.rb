class Zix < Formula
  desc "C99 portability and data structure library"
  homepage "https://gitlab.com/drobilla/zix"
  url "https://gitlab.com/drobilla/zix/-/archive/v0.8.2/zix-v0.8.2.tar.gz"
  sha256 "a2464cdc11fa359b5e713b3c82bf0b476952efe397a02374ddbc1b62eee04f13"
  license "ISC"
  head "https://gitlab.com/drobilla/zix.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9b81090cc858205cb0e9df02cd9104e91ec96f5ffb5c22240e8850f7bda4b223"
    sha256 cellar: :any, arm64_sequoia: "73ab925a8aa5e59105e03ceeff0b010eba86db3605f9fd9d8939afb755fa7561"
    sha256 cellar: :any, arm64_sonoma:  "701f7c57b3d86135f5c93ff8b146c5c486fba0c01b9fbb38f302aac1f3876e56"
    sha256 cellar: :any, sonoma:        "0ad2844db475641396028cbbdc412355676eddf15cada6b203b77389b32cefb4"
    sha256 cellar: :any, arm64_linux:   "8a0603a74f3102f584c070c5d5d1ca29b1d06d440d6a567e0ea612b046bbb327"
    sha256 cellar: :any, x86_64_linux:  "12807bb561e101cebe9d22ce4382b720b1285b2ade4dcfdfb4820fd21b48e39f"
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
