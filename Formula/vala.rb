class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://wiki.gnome.org/Projects/Vala"
  url "https://download.gnome.org/sources/vala/0.52/vala-0.52.0.tar.xz"
  sha256 "1de26310db465aca525679d3b5a3c1d8db2e067c4cbc0e5ddd015cd938bac68b"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_big_sur: "d11bc6d03fb1db4083f1946c028e72517dbb216f96b5ed4a00a34e916c2a4087"
    sha256 big_sur:       "9992a0485766388a0a166346353b31fb336d2e90d02a9748166d82b68aff1bb9"
    sha256 catalina:      "eab48df8949d7a99fc3c91154b7c7cdaf6ae71c98812b2bbff5ace9517d2130c"
    sha256 mojave:        "d03a5846affb4c071e3515df488155a34b02da24b7cd119bde44e06da6197f22"
  end

  depends_on "gettext"
  depends_on "glib"
  depends_on "graphviz"
  depends_on "pkg-config"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make" # Fails to compile as a single step
    system "make", "install"
  end

  test do
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libffi"].opt_lib/"pkgconfig"
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
