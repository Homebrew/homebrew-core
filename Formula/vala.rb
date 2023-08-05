class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://wiki.gnome.org/Projects/Vala"
  url "https://download.gnome.org/sources/vala/0.56/vala-0.56.10.tar.xz"
  sha256 "a83ad3af4228f02f2510f8a3e4f3c4f9c36c8605b1261ce6d5d53be35ba1fc4d"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_ventura:  "15b716e933f40110963232c24d55c0b16963fd0c04229005f2c8ff29adcfd8d3"
    sha256 arm64_monterey: "7edaeba6c4e0abb4119798f4f1b4d904fc7e6de8428eb1c70679bb2654ed1716"
    sha256 arm64_big_sur:  "9fc271d006fa8fe9d9718f83f11828db05cf22fd39b1ecad6b9544017e96ede4"
    sha256 ventura:        "cf1c768324b043c8601b007e32e331f17502f0f5cb2231b0ce257413f7e936f0"
    sha256 monterey:       "32d3d0a9b89f0470ba66966fe8b5e97399ca1f287b5494e35f705558d0c54576"
    sha256 big_sur:        "154d29de9b39f7cc96d46962e0e3b3add880c127c8c458f1efde7c1954440a4a"
    sha256 x86_64_linux:   "e957fe09e8a8bc5c49b1bab21bfb9cc4ce26d3151abc5784d16000b540735e61"
  end

  depends_on "glib"
  depends_on "graphviz"
  depends_on "pkg-config"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "libxslt" => :build # for xsltproc

  on_macos do
    depends_on "gettext"
  end

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make" # Fails to compile as a single step
    system "make", "install"
  end

  test do
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libffi"].opt_lib/"pkgconfig"
    test_string = "Hello Homebrew\n"
    path = testpath/"hello.vala"
    path.write <<~EOS
      void main () {
        print ("#{test_string}");
      }
    EOS
    valac_args = [
      # Build with debugging symbols.
      "-g",
      # Use Homebrew's default C compiler.
      "--cc=#{ENV.cc}",
      # Save generated C source code.
      "--save-temps",
      # Vala source code path.
      path.to_s,
    ]
    system "#{bin}/valac", *valac_args
    assert_predicate testpath/"hello.c", :exist?

    assert_equal test_string, shell_output("#{testpath}/hello")
  end
end
