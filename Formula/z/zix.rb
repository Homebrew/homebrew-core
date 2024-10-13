class Zix < Formula
  desc "C99 portability and data structure library"
  homepage "https://gitlab.com/drobilla/zix"
  url "https://gitlab.com/drobilla/zix/-/archive/v0.4.2/zix-v0.4.2.tar.gz"
  sha256 "f6e885025d516638d07e1ead6a809be75790355c47c1143272e69b9153321ed4"
  license "ISC"
  head "https://gitlab.com/drobilla/zix.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "eb620be166a0f863628ac51435c6831cc815c2177759ddecaf35d91bf44dfaaf"
    sha256 cellar: :any,                 arm64_sonoma:   "de2695c9a13e9503c8d1ac8a9214f78ce3a0aa4780a61de4680cf551ff33d086"
    sha256 cellar: :any,                 arm64_ventura:  "33009c89adb75856bdfa543b31ddc1696358e3f39b9fb92e0b55bae7a4db9e28"
    sha256 cellar: :any,                 arm64_monterey: "1aa17041299618bf01269c414131d7b2ff0dc74732e825b41a7b66c251447847"
    sha256 cellar: :any,                 sonoma:         "d8435c8e9e3a5753ed713366ae736b135257f29952049c4b233fa7f08e0ec27c"
    sha256 cellar: :any,                 ventura:        "1add27a68635d9b065694cf46e26fb0069e7782748c7272b0c57cf67dd45259a"
    sha256 cellar: :any,                 monterey:       "ec944e9f9fd697dc6341c69419f7a922f949e44b3e3598794c1d1683c7034a06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "667583fc8f16b2297f949407233524d146ad1bf7ec1f87f625aa70f7b8728879"
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
    (testpath/"test.c").write <<~EOS
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
    EOS
    system ENV.cc, "test.c", "-I#{include}/zix-0", "-o", "test"
    system "./test"
  end
end
