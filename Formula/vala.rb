class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://wiki.gnome.org/Projects/Vala"
  url "https://download.gnome.org/sources/vala/0.48/vala-0.48.2.tar.xz"
  sha256 "f095b0e624b8f4e5a426028ac255e477fad8c3b4c8cbbdebda8d6cd95bf79477"

  bottle do
    sha256 "f766980a66d4ef11512d0c52f6b21905bc030423f457433a2206a6b1772215e1" => :catalina
    sha256 "89dc62a2a8e5a43cdeccc05d439e1c37883c23195fb48e28de09223d94739ecb" => :mojave
    sha256 "05472ac7b3b3ea65d3942afd65d69c8e11434182ef92177842ca32f90f841f64" => :high_sierra
  end

  depends_on "gettext"
  depends_on "glib"
  depends_on "graphviz"
  depends_on "pkg-config"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

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
