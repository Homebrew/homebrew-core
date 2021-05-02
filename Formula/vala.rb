class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://wiki.gnome.org/Projects/Vala"
  url "https://download.gnome.org/sources/vala/0.52/vala-0.52.3.tar.xz"
  sha256 "037ea1a92bf0f1ab04a71b52a01d50aca1945ad1017b6189d9614f84f5c9b2d9"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_big_sur: "c2c57dfe5ac0d4e4c4e628a7a7a4e36ca336f48b2960019dd0f91a1891b8b4b7"
    sha256 big_sur:       "b0848409164c648b574d567955a3a23217810030a4e611d6ce74189e7c89e903"
    sha256 catalina:      "263a86c9b00822a325cdea8d47c4d647721baf0f6b48ee8b96fad758ddc8a1d5"
    sha256 mojave:        "cd02fc8279c33a8773db5550b960ae1bc42a02471330723196eb220413214dea"
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
