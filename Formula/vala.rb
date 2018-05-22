class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://live.gnome.org/Vala"
  url "https://download.gnome.org/sources/vala/0.40/vala-0.40.5.tar.xz"
  sha256 "1203a41f5943912450dc55f889bd1018c551a080c893cc6e8303fb47c7fde16d"

  bottle do
    sha256 "c9d1fe9d52e538802224794fa999011afd21b2988207e15cd8425530e41ff671" => :high_sierra
    sha256 "1a4b4df622b12f3630dd15b4a510842f1f3668524912374dac88b4cffc134cc6" => :sierra
    sha256 "49fa86ae666780360d10f9e385f24bb695a6fd70b6bee8653da6116bf7a4100e" => :el_capitan
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
