class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://live.gnome.org/Vala"
  url "https://download.gnome.org/sources/vala/0.38/vala-0.38.4.tar.xz"
  sha256 "2cb33a63bd17737e72f5f4f9ca4109f398500ee1f17a01ff4ef94139b07ae5e9"

  bottle do
    sha256 "e38a9bed5ecdbcaa8037ad5f5f94426a3631825dde79c6c4ca7dd6b2834b9044" => :high_sierra
    sha256 "9c90aeb93d320f87ce8fd7284928c061e596b234112b210ae8966d5888c6877f" => :sierra
    sha256 "e58858915ba78a2917a1e2488a56e9cc8ea79e7a034ee6a8649a086d0697de95" => :el_capitan
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
