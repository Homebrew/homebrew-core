class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://wiki.gnome.org/Projects/Vala"
  url "https://download.gnome.org/sources/vala/0.56/vala-0.56.12.tar.xz"
  sha256 "92c9d54b7cbea3a97077e5d981c8d1b5d06eb285ed159aecab9c58d110253559"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_ventura:  "5d9b2825e139a6dd4c838935150b9a44291ce7ea378317487e3db3e1f4dad054"
    sha256 arm64_monterey: "09b7fc4227cf891fc81b3836b134c542877f34e55680389ba3c3f3b6ef3d1365"
    sha256 arm64_big_sur:  "9b42ec70010b25c0cd9449a2187e3c1ae45084f4cb50a3b8b1127b84999bef0d"
    sha256 ventura:        "10c3081c733d1c6de287df541b5c682ead74169a4db6229fa1caf34478b0d240"
    sha256 monterey:       "0b518b795ba3db053673c1f20c8f479e09b3ec8c1ffc2efa559c27cd70180563"
    sha256 big_sur:        "0bc7aeff941f8a53c9cc50c89a9dc776ce2f2a99a41b7b400882188fad189d8c"
    sha256 x86_64_linux:   "40a010b1572ebe34504748d44c8c7842aa2d75db2e70fa2ceb58bb51d2c8c707"
  end

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
    system "#{bin}/valac", *valac_args
    assert_predicate testpath/"hello.c", :exist?

    assert_equal test_string, shell_output("#{testpath}/hello")
  end
end
