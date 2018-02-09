class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://live.gnome.org/Vala"
  url "https://download.gnome.org/sources/vala/0.38/vala-0.38.7.tar.xz"
  sha256 "09d10f5f7d0e4b3c905d9f636cb5ac55f317494e42c75e6572be4138b0603405"

  bottle do
    sha256 "e900b93cbc3c761c8c8996a6359842e804015d4142f682b946c189292b61c091" => :high_sierra
    sha256 "e305aebb1e74b7a66fa53f8d9551412cf3e35c0823f90704c2e249d09a7b074d" => :sierra
    sha256 "6b73cef8a92c2ff5e74391234a76f069f69c6fce040ecfa34595505d3dd09b35" => :el_capitan
  end

  depends_on "pkg-config" => :run
  depends_on "gettext"
  depends_on "glib"
  depends_on "graphviz"

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
    path.write <<-EOS
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
