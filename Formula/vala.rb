class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://live.gnome.org/Vala"
  url "https://download.gnome.org/sources/vala/0.38/vala-0.38.3.tar.xz"
  sha256 "4addaff4625b203763c454e81b928219d41e152f9982c836c72094d3315d6854"

  bottle do
    sha256 "938663a8ad34b6e4d3bf07a789324c1bbbde0488270e9784899d7715984cd4f1" => :high_sierra
    sha256 "1e661d527bc74e31ad5ef398c7246cdeb779c33bda31bb033ebb56d2270d2d34" => :sierra
    sha256 "cb8c2b6258a2b8dfde673ad1d6efdd89ce47ff392779d17f5095ada8256b656a" => :el_capitan
  end

  depends_on "pkg-config" => :run
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
    path.write <<-EOS
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
