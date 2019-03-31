class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://wiki.gnome.org/Projects/Vala"
  url "https://download.gnome.org/sources/vala/0.44/vala-0.44.2.tar.xz"
  sha256 "67d9bb4656d8fe04bcfc1ed7ff35d191df425923de46c921ae3c3d996eee8040"

  bottle do
    sha256 "40645b5a8ffa8995befe9afa1ba6d619b74f4d0301740fdf8bbddc5c1f59a4e6" => :mojave
    sha256 "eed42d5910f15ba6336c045e70004fd72d66eef3ee9cb512889064434ee6ed79" => :high_sierra
    sha256 "f8ad68ef7bf009e6ce0d1e8eb5f608658838df18566fb67c77f8d9ad83614e07" => :sierra
  end

  depends_on "gettext"
  depends_on "glib"
  depends_on "graphviz"
  depends_on "pkg-config"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
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
