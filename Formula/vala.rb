class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://wiki.gnome.org/Projects/Vala"
  url "https://download.gnome.org/sources/vala/0.42/vala-0.42.2.tar.xz"
  sha256 "9e89aa42152b1cef551568f827aa2deea2a9b5487d78c91474c8617b618e5f07"

  bottle do
    sha256 "1f7ef67af91976e069d9722d0e0807576751c78b6130f0ed98afb9cbd4d5c7db" => :mojave
    sha256 "f24f20f39730f4029ab62fd5ccce4c31fb3283122623435f7941e2de759ad450" => :high_sierra
    sha256 "8fef70f4cf5df946f2514b37c1b451d9212338ac819f837ce4dcf539c1444156" => :sierra
    sha256 "6aa59e49e9f7d10414abc3162c9085e46a1bb84919dd7583e633d5dd11a71a1b" => :el_capitan
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
