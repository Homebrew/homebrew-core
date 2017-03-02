class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://live.gnome.org/Vala"
  url "https://download.gnome.org/sources/vala/0.34/vala-0.34.5.tar.xz"
  sha256 "3fd4ba371778bc87da42827b8d23f1f42b0629759a9a1c40c9683dfb7e73fae5"

  bottle do
    sha256 "a466a3eac6b57099656f1b1da6b4a2d5673c3efd1da5510dec0294fe6e67e75a" => :sierra
    sha256 "e7cac8843b7a5e5251d46cf1ad44054b9ad40117b97a6788279009aa11a0b41c" => :el_capitan
    sha256 "b4e1203ff4c793e6fcd94da5710049af032f0e5bd675b1c06138750495d8ac33" => :yosemite
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
