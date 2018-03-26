class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://live.gnome.org/Vala"
  url "https://download.gnome.org/sources/vala/0.40/vala-0.40.1.tar.xz"
  sha256 "79b544305640b00010008cad0df1a1742363f636e4a7e3d410f651edc728f605"

  bottle do
    sha256 "a8c354179b2f848105170eaea07f9233cc4c5d3aa331b0a72cf982873bcd1b15" => :high_sierra
    sha256 "43e1e6174f161560626467f41813576665cbd26b21260c56699bd4888397b2a1" => :sierra
    sha256 "ed87e4796f54a9c26d0cc7ad2928b49a21be692935cb3640f9df3a7ec0c8ef31" => :el_capitan
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
