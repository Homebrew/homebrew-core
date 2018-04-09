class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://live.gnome.org/Vala"
  url "https://download.gnome.org/sources/vala/0.40/vala-0.40.3.tar.xz"
  sha256 "6d4f1f0b2edaa0d4aa96f72735a9845e6b1acf80a0a2ae494b5d43e07833119e"

  bottle do
    sha256 "24a1609a838cb74183b035d1e1678b9fdae305f644ee8e9f8e71b6eabf69b7b7" => :high_sierra
    sha256 "e70c25bd1ab1ed8cf5c15f2ca703df1716d4f266815252606d9de8ffda9e901e" => :sierra
    sha256 "8b5c196e7b9c6ce73a6913fb5af741638ea24c36b7e6e4b7d91357e6680d282f" => :el_capitan
  end

  depends_on "pkg-config"
  depends_on "gettext"
  depends_on "glib"
  depends_on "graphviz"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make" # Fails to compile as a single step
    system "make", "install"
  end

  test do
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
