class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://live.gnome.org/Vala"
  url "https://download.gnome.org/sources/vala/0.40/vala-0.40.7.tar.xz"
  sha256 "bee662f60ab3a0d5266c1dd66f508cd9ed3254d74622d23c2d6bd94c91990aec"

  bottle do
    sha256 "aa560f85748445ac1e944e5f1844edc464466de68155f5092c7fa46930b036d8" => :high_sierra
    sha256 "bc33668a65feba43a83b47cf1a1e4b49fc552de84ee77f68fc2cf02ea682fee4" => :sierra
    sha256 "7fce4eced6560d8746ceb81e4ebc1284365fbbbcb9123b59a505e2407055c536" => :el_capitan
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
