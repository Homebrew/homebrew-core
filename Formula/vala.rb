class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://live.gnome.org/Vala"
  url "https://download.gnome.org/sources/vala/0.38/vala-0.38.4.tar.xz"
  sha256 "2cb33a63bd17737e72f5f4f9ca4109f398500ee1f17a01ff4ef94139b07ae5e9"

  bottle do
    sha256 "26e83ce3d1dc33b56799555d24337d2a8269edb09b0afa8a19c7f1aa113e5327" => :high_sierra
    sha256 "5e90527f89fa666ae63f0e32ba6faebe5c86c03c79567a42616b1f9c860b1ad0" => :sierra
    sha256 "9cd49650197eb844f7332a18e87db04b8b1de70ebaeb8bf96a535a861f66e3f0" => :el_capitan
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
