class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://wiki.gnome.org/Projects/Vala"
  url "https://download.gnome.org/sources/vala/0.42/vala-0.42.5.tar.xz"
  sha256 "8c33b4abc0573d364781bbfe54a1668ed34956902e471191a31cf05dc87c6e12"

  bottle do
    sha256 "9c6c86b7f494f23a71204ef1ea9557bb7451c0af221cc8dd1cdf9a08bf80bc1e" => :mojave
    sha256 "57491a07b55149a072f8d630fa3faabc62237eaaaef1d22c7a8c8b84850f7874" => :high_sierra
    sha256 "167682d16807eff93bdcf20e59bb851a4b6cc46e6c61981a1db1128329aad9c2" => :sierra
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
