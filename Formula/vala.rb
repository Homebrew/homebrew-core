class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://wiki.gnome.org/Projects/Vala"
  url "https://download.gnome.org/sources/vala/0.42/vala-0.42.6.tar.xz"
  sha256 "3774f46fed70f528d069beaa2de5eaeafa2851c3509856dd10030fa1f7230290"

  bottle do
    sha256 "51c9fe61fe3b1b680c8208cc0bbc83fa0f0ea8f7ee4c4ddabad3cbb4bcf953fb" => :mojave
    sha256 "e531087ef3b3b1c7c28a7560cbe5b92f1b547b9a049c01e46b990c15c4afc495" => :high_sierra
    sha256 "f623af0de13794641e85ad057b9955f8dac56da2445a0df41ea364de2baa6f6f" => :sierra
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
