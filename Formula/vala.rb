class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://wiki.gnome.org/Projects/Vala"
  url "https://download.gnome.org/sources/vala/0.48/vala-0.48.9.tar.xz"
  sha256 "9cea16d3bb3daddbfe0556b99fbfa08146230db7651e1e674cd08b4df5cefea9"
  license "LGPL-2.1"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "0974525fc540e9c752850d94fc5fb22afac2b79ce3b1ff129ffe9c624e1c8ada" => :catalina
    sha256 "09e93932b9bcf305bc27e74cbd5ae72d615570c791b8545d085c56d4891eb1fe" => :mojave
    sha256 "53f2c287bb6a36ae9c66986706762a4542a994545f70571280f0d9f5dab37879" => :high_sierra
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
