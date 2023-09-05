class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://wiki.gnome.org/Projects/Vala"
  url "https://download.gnome.org/sources/vala/0.56/vala-0.56.13.tar.xz"
  sha256 "4988223036c7e1e4874c476d0de8bd9cbe500ee25ef19a76e560dc0b6d56ae07"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_ventura:  "4be8dd3450e20f94696cefde19dbd8422096f31071d3a42c504d555ddcd94ef3"
    sha256 arm64_monterey: "500baf087715b8991dae0e931217a3fd002820bb141d054d51d6b6b8d3ab334e"
    sha256 arm64_big_sur:  "210e6ee4ccfd4ce57a0433d210d9384c5f0fbe66907f82ad8a2ce387df42ffdc"
    sha256 ventura:        "f5eec271ad74248f896ccb0e4903c8b1bc63630a4cf3fa4c024751bd54f207e5"
    sha256 monterey:       "280ad99b326280c9af80d58a781b3c9b8b7f665db64d8211a3b48e4bc2fa9136"
    sha256 big_sur:        "bb2b5252e313d18abc34bebcf793438d7b529986146d3cde0c494456c341fc58"
    sha256 x86_64_linux:   "0023a45bf46588e6bbb9e564f5dbef8b616252f68dfc5371535bb695c90e8bb3"
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
