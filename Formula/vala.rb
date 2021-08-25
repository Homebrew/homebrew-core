class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://wiki.gnome.org/Projects/Vala"
  url "https://download.gnome.org/sources/vala/0.52/vala-0.52.5.tar.xz"
  sha256 "84a1bb312b3e5dcae4b7b25c45598d375e2cb69233cefb59a15d2350c76bdd91"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_big_sur: "27f97c3f3093cf9c4c29c580b3c8351a486eacc43fa63ee51ef6109cdcbbc65b"
    sha256 big_sur:       "518b8509cddac731842cf247ddb3b0ebd38af31fa8ecd7ae9897df47c5dc5e8c"
    sha256 catalina:      "96c83c0387c9641a9cd633b8854e44f93651e5ba1a27a76b2527974185ea09b7"
    sha256 mojave:        "2f398bd56d4668ec8f44291eb6b2566c92809222baa9c1750888e50276a7fd16"
    sha256 x86_64_linux:  "f73e1af9df1d9dd3cf75d85bb84862686cfc0be6d2ab91eda06a40ff2a0f76bd"
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
