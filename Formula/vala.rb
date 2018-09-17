class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://wiki.gnome.org/Projects/Vala"
  url "https://download.gnome.org/sources/vala/0.42/vala-0.42.1.tar.xz"
  sha256 "b4a52524207aadc77f4b39e29e4375387d2b6efe40738b33434e3298ebdabb11"

  bottle do
    sha256 "06b85a7575c5adbd9fccaa7b2c541da747e51e6471483cf1d63201c3595c9aaa" => :mojave
    sha256 "9a8ddd7921d244d41d336b04f8c5395735d3815d302f32e96985e1dbf2d0d83d" => :high_sierra
    sha256 "9b99aa038ce86e74dd14f2a97111c3f77542ba1c7d74550089d04b7b079a1118" => :sierra
    sha256 "cf52d824c26ff0ef76918ccb3bede88945f3f88145396b5dc32263890be46cef" => :el_capitan
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
