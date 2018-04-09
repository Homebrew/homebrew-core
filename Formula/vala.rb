class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://live.gnome.org/Vala"
  url "https://download.gnome.org/sources/vala/0.40/vala-0.40.3.tar.xz"
  sha256 "6d4f1f0b2edaa0d4aa96f72735a9845e6b1acf80a0a2ae494b5d43e07833119e"

  bottle do
    sha256 "e7e393ad7135aaae4a0fedea2d63fae295d03576e72c5ab391aa76f47ed67c23" => :high_sierra
    sha256 "ad064e8fe52934e6d343ba9713cb70966f7f34f370cd365c0c0b82472f4ef690" => :sierra
    sha256 "e8072336c19758441d1ba46ba01198d818ff776cda4c45c92082a543808cc1e7" => :el_capitan
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
