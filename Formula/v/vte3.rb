class Vte3 < Formula
  desc "Terminal emulator widget used by GNOME terminal"
  homepage "https://wiki.gnome.org/Apps/Terminal/VTE"
  url "https://download.gnome.org/sources/vte/0.84/vte-0.84.0.tar.xz"
  sha256 "0414e31583836aeb7878da25f67c515f7e8879917ecc37c92e26b83e8d8fc3e3"
  license "LGPL-2.0-or-later"
  compatibility_version 1

  bottle do
    sha256 arm64_tahoe:   "e8d84b9045e2ad4766cf720d8571e2f3d5ce5bf02272547bf7dfe0867ca5f8c2"
    sha256 arm64_sequoia: "9909f37286e98bb1923785a40d0c953e21c5ad5ac8b3f87c3646a875570ce289"
    sha256 arm64_sonoma:  "6b323dc1dff3daac79febb60f696b2f3fb76d95d038ae9c0ee416ff509c4dbf4"
    sha256 sonoma:        "a5def4efce2aaecf9bc8c8232077f286b7b35a56cf7ab9afd5bb8187965c96aa"
    sha256 arm64_linux:   "fdefd2a0f307996f347c16c12557070ec87b40143570aac75e8870ff7533fd01"
    sha256 x86_64_linux:  "7fb10c27d41d88059750995a0cb4f5d2e5a2d63ebab82917cd3ded63793b45d0"
  end

  depends_on "fast_float" => :build
  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "vala" => :build

  depends_on "at-spi2-core"
  depends_on "cairo"
  depends_on "fribidi"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gnutls"
  depends_on "graphene"
  depends_on "gtk+3"
  depends_on "gtk4"
  depends_on "icu4c@78"
  depends_on "lz4"
  depends_on "pango"
  depends_on "pcre2"
  depends_on "simdutf"

  uses_from_macos "python" => :build

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1699
    depends_on "gettext"
  end

  on_linux do
    # Ubuntu 24.04 has GCC 14 libstdc++ so we can build with brew GCC 14 without impacting GLIBCXX
    depends_on "gcc@14" => :build if DevelopmentTools.gcc_version < 14
    depends_on "systemd"
  end

  # https://developer.apple.com/xcode/cpp/#c++23
  fails_with :clang do
    build 1699
    cause "Requires C++23 std::out_ptr"
  end

  # https://en.cppreference.com/cpp/compiler_support/23#cpp_lib_out_ptr_202106L
  fails_with :gcc do
    version "13"
    cause "Requires C++23 std::out_ptr"
  end

  def install
    if OS.linux? && deps.map(&:name).any?("gcc@14")
      # Since brew will prioritize newer GCC versions if installed, we force usage of gcc-14
      ENV.method(:"gcc-14").call

      # Avoid using the postinstalled specs file which automatically adds an RPATH to gcc@14 libraries
      libgcc = Pathname.new(Utils.safe_popen_read(ENV.cc, "-print-libgcc-file-name")).parent
      ENV.append "CXX", "-specs=#{libgcc}/specs.orig"
    end

    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    system "meson", "setup", "build", "-Dgir=true",
                                      "-Dgtk3=true",
                                      "-Dgtk4=true",
                                      "-Dgnutls=true",
                                      "-Dvapi=true",
                                      "-D_b_symbolic_functions=false",
                                      *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <vte/vte.h>

      int main(int argc, char *argv[]) {
        guint v = vte_get_major_version();
        return 0;
      }
    C
    flags = shell_output("pkgconf --cflags --libs vte-2.91").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"

    flags = shell_output("pkgconf --cflags --libs vte-2.91-gtk4").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
