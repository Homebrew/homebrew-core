class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://live.gnome.org/Vala"
  url "https://download.gnome.org/sources/vala/0.40/vala-0.40.0.tar.xz"
  sha256 "15888fcb5831917cd67367996407b28fdfc6cd719a30e6a8de38a952a8a48e71"

  bottle do
    sha256 "497fb9e36ce416b0ef6b0e1a7961f57b6ee316b74016f995b24579648c58e420" => :high_sierra
    sha256 "76106162323113686ae19f33b07a13cde8d122e9cb32bf4d460533ea05668826" => :sierra
    sha256 "c2a2803b8d5326b293d4bc3a154acd733a5aa75626302456bd3ee000b8e26908" => :el_capitan
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
