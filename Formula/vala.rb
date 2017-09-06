class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://live.gnome.org/Vala"
  url "https://download.gnome.org/sources/vala/0.38/vala-0.38.0.tar.xz"
  sha256 "2d88f3961ea64c17f2fe14ad61db9129dd42b4f6de41432ad6a1a29ffe05c479"

  bottle do
    sha256 "e29c8a92e81b691f8cba91166122787fab7eef16fef23a2406205d3bc0f4803b" => :sierra
    sha256 "439b2ed4ba49af3996b6008726c83df441bf472a6f11f76708dd1fbf05e13636" => :el_capitan
    sha256 "133f2aaa6d4adfd9e71d607b8426ad23c327b756b2a65c8e8c67df4f9fe8d367" => :yosemite
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
    assert File.exist?(testpath/"hello.c")

    assert_equal test_string, shell_output("#{testpath}/hello")
  end
end
