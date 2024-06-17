class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://wiki.gnome.org/Projects/Vala"
  url "https://download.gnome.org/sources/vala/0.56/vala-0.56.17.tar.xz"
  sha256 "26100c4e4ef0049c619275f140d97cf565883d00c7543c82bcce5a426934ed6a"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sonoma:   "08ca53b37c7464bc3990246568ca344ddfa7ee9e38b8cffdea01a5fe9c183a17"
    sha256 arm64_ventura:  "867b615ee4cb52de204837b74acb80d203c62cef97efe1b68117744390a4512b"
    sha256 arm64_monterey: "7a23986c89b3f2ee3583cf8119932b624f436c923f489d9e8bdbf79f74fa014d"
    sha256 sonoma:         "ba82671da132ae4ea92c29778f8c13e8d92770bfb8d28a282f257d808ad33c8c"
    sha256 ventura:        "f0845abb3bcd9b8a091b5f44aa98f6cbc2d49391dcc9f893df93692f4b1cbd8b"
    sha256 monterey:       "90bbb65556e3c267dc893f2380fd7d9cb7f54544da3f0434e378d353984a0743"
    sha256 x86_64_linux:   "7a61d8199a2837ca08d9a400f9a4eb9c72559e5962c62b53b4fbcaa80bf3fe08"
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
    system "#{bin}/valac", *valac_args
    assert_predicate testpath/"hello.c", :exist?

    assert_equal test_string, shell_output("#{testpath}/hello")
  end
end
