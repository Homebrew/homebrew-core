class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://wiki.gnome.org/Projects/Vala"
  url "https://download.gnome.org/sources/vala/0.42/vala-0.42.3.tar.xz"
  sha256 "5fc73dd1e683dc7391bb96d02b2f671aa8289411a48611a05265629e0048587d"

  bottle do
    sha256 "e901a77a3ae7ec135562e57ddcaba96d41572487ee405009ebbb969ec07ede62" => :mojave
    sha256 "c534ae2bf694890851ac84eab6256b6239f89f9c41ba190f059449d28376b92d" => :high_sierra
    sha256 "66e977ba42959cac5921a1a8a75af1afaacb69340e2e35b713b6d0b38899112b" => :sierra
  end

  depends_on "gettext"
  depends_on "glib"
  depends_on "graphviz"
  depends_on "pkg-config"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make" # Fails to compile as a single step
    system "make", "install"
  end

  test do
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
