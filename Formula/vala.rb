class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://live.gnome.org/Vala"
  url "https://download.gnome.org/sources/vala/0.34/vala-0.34.3.tar.xz"
  sha256 "f0fad71aca03cdeadf749ca47f56296a4ddd1a25f4e2f09f0ff9e1e3afbcac3f"

  bottle do
    sha256 "753e21159857f26069bf64ae2a3137c445a72e0d2b5d8fe2b9c9263480c6df40" => :sierra
    sha256 "669cfa17a3563a234a9e0bd75d39c5be25ca44c6903e3b192acaf3eaee18e23b" => :el_capitan
    sha256 "9d82bdc6e081c4f14996361d108be5c0408a621dbfa3242eab67a8b5b68b425f" => :yosemite
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
