class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://wiki.gnome.org/Projects/Vala"
  url "https://download.gnome.org/sources/vala/0.46/vala-0.46.0.tar.xz"
  sha256 "a10a3b9d60bdfe3349afd3778cd4518b1eb517b59134a70ab5ac845432220c17"

  bottle do
    sha256 "dad27d9adb3a07b4e442bae8356a6bd51fbc1ee81853ddc96d30ca168e294ae2" => :mojave
    sha256 "25e9352121aaacc6ec671b855dd7a445b0be1feeea82b13fa01d3d751bfa0eef" => :high_sierra
    sha256 "550a8685b78ef3477d8d87b575ee24b89e3a120a6631ab9be17765e5235bc86c" => :sierra
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
