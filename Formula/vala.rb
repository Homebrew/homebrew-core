class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://live.gnome.org/Vala"
  url "https://download.gnome.org/sources/vala/0.38/vala-0.38.7.tar.xz"
  sha256 "09d10f5f7d0e4b3c905d9f636cb5ac55f317494e42c75e6572be4138b0603405"

  bottle do
    sha256 "f6e204de47e3538d1c597918153ef728ae6d6f5153d949a37b82dba45d0daeba" => :high_sierra
    sha256 "bdc70e77dc4cb79c1bf0d93a6108bd8e1e8c066e72a1bd4df5eb220ea4406f79" => :sierra
    sha256 "cd6b078d0e9926acd9777b1d0fbaf420dbadae310518c85db4357f40d7c4229b" => :el_capitan
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
