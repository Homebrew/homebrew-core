class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://live.gnome.org/Vala"
  url "https://download.gnome.org/sources/vala/0.36/vala-0.36.4.tar.xz"
  sha256 "e9f23ce711c1a72ce664d10946fbc5953f01b0b7f2a3562e7a01e362d86de059"

  bottle do
    sha256 "d60bff583c824ca374f2ddec37b573969997e9c4a81a164cfda4a61dfe36f1be" => :sierra
    sha256 "b407a8a0f68aa009f78a8dc91dc8af053d044243081ac3e6945b7ff8364f22f1" => :el_capitan
    sha256 "0ea438c7d9a22cf4c93e7efc0ad75eeb9e6e68197303e5df582b6b6706bfb249" => :yosemite
  end

  depends_on "pkg-config" => :run
  depends_on "gettext"
  depends_on "glib"

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
    assert File.exist?(testpath/"hello.c")

    assert_equal test_string, shell_output("#{testpath}/hello")
  end
end
