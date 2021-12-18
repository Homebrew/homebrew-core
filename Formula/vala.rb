class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://wiki.gnome.org/Projects/Vala"
  url "https://download.gnome.org/sources/vala/0.54/vala-0.54.5.tar.xz"
  sha256 "0028da1685dedca993792bfb5f460db5ba548c9aa44323b1899f733a89121587"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_big_sur: "85cc68c5eff58b173149ccdd03d0b78c97808b01d0151de701cb0f992f3407e6"
    sha256 monterey:      "9340ebf84dcbf5942fca5a31dec33cd54bf0b6f50dce835cb1c0b431594ca560"
    sha256 big_sur:       "a88995393f7c6f77d2f570f3cca4ab6cc53531e9985285e581d6468e48bc9357"
    sha256 catalina:      "dc6856c543e6ac8b93661d666cf09439ce8af840f046f5838de117d4890bd172"
    sha256 x86_64_linux:  "8a4e6e2bb33b6183574f4d158dac46109e5b43b300de3c86bab6b626cc83dc42"
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
