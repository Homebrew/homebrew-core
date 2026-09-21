class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://wiki.gnome.org/Projects/Vala"
  url "https://download.gnome.org/sources/vala/0.56/vala-0.56.19.tar.xz"
  sha256 "5ad7cbbfcc0de61b403d6797c9ef60455bfbebd8e162aec33b5b0b097adfb9d5"
  license "LGPL-2.1-or-later"
  revision 1

  bottle do
    sha256 arm64_golden_gate: "05f822310b3a2ff54b5b8a04516fdcdddccc6081cee03a12da66366e10210c38"
    sha256 arm64_tahoe:       "7236e77a2e6bcc1b77d1cd7c8eade63f63459fee2c0429b84348eb86cd1d81b3"
    sha256 arm64_sequoia:     "ca08db6836916f2a967cfc8a289ebd93105e793385b9e0a37076e4fb770a8b85"
    sha256 arm64_sonoma:      "b12ea61f9b9c19b0722e6309562b498d28deb797234af0280d9b3692b8aaf8a5"
    sha256 arm64_linux:       "b911b1f58457e8fad4111c554c423beddbb86f6dde92b246dc54fd706f1e0a43"
    sha256 x86_64_linux:      "459104ac47129f0fe09759497678a9ce7cc2e5bcb89b050e6589ea9ae4a0480d"
  end

  depends_on "gobject-introspection" => :build
  depends_on "glib"
  depends_on "graphviz"
  depends_on "pkgconf"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "libxslt" => :build # for xsltproc

  on_macos do
    depends_on "gettext"
  end

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make" # Fails to compile as a single step
    system "make", "install"
  end

  test do
    ENV.prepend_path "PKG_CONFIG_PATH", formula_opt_lib("libffi")/"pkgconfig"
    test_string = "Hello Homebrew\n"
    path = testpath/"hello.vala"
    path.write <<~VALA
      void main () {
        print ("#{test_string}");
      }
    VALA

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
    assert_path_exists testpath/"hello.c"

    assert_equal test_string, shell_output("#{testpath}/hello")
  end
end
