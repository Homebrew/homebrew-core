class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://live.gnome.org/Vala"
  url "https://download.gnome.org/sources/vala/0.36/vala-0.36.0.tar.xz"
  sha256 "d27c9d11302ce6e521d616c89ea509f887de449fa4728d004e51d8f9646a775e"

  bottle do
    sha256 "0089fd30dd03fa54550f9a321ddc5b9879329316d31e5162f4cbaa0350760948" => :sierra
    sha256 "7622a1941cbc4477b8bd8e16774426047faa5f7465fb3e61fce586f20fdd41d6" => :el_capitan
    sha256 "2fae06e3039c6376f738d789ba34318aec68b13946b8eb5a882a70ca69f4ce01" => :yosemite
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
