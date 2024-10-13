class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://wiki.gnome.org/Projects/Vala"
  url "https://download.gnome.org/sources/vala/0.56/vala-0.56.17.tar.xz"
  sha256 "26100c4e4ef0049c619275f140d97cf565883d00c7543c82bcce5a426934ed6a"
  license "LGPL-2.1-or-later"

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "d7b95eef607afc1c5d6e142d258a3ffcc532e5b50e982083a9e971bbea2cd615"
    sha256 arm64_sonoma:  "97567ffe29dacc84af84a2abc1d67a83a04ec3c7b37dee093ab0a34b454fc55c"
    sha256 arm64_ventura: "643a79f04dce15f6a65deeebc7137965d842befcdb716fbefa2f528a0046e6be"
    sha256 sonoma:        "b4aed882d3810fa13006a72460796c14b970b6802c8783c9e49af34bbf43ba92"
    sha256 ventura:       "9c3bfb8a007ebcdd431eaee96807b3730b3a621ea5842c522621c24547272f20"
    sha256 x86_64_linux:  "39bd5991d99ae03c4f00e6b1c1f5e7216d5ac7543c34f620c39151a00d931c49"
  end

  depends_on "gobject-introspection" => :build
  depends_on "glib"
  depends_on "graphviz"
  depends_on "pkg-config"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "libxslt" => :build # for xsltproc

  on_macos do
    depends_on "gettext"
  end

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
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

    system bin/"valac", *valac_args
    assert_predicate testpath/"hello.c", :exist?

    assert_equal test_string, shell_output("#{testpath}/hello")
  end
end
