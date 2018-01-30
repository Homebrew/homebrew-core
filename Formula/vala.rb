class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://live.gnome.org/Vala"
  url "https://download.gnome.org/sources/vala/0.38/vala-0.38.6.tar.xz"
  sha256 "8c676b8307a12fba3420f861463c7e40b2743b0d6fef91f9516a3441ea25029a"

  bottle do
    sha256 "150b7256d075c214a570cbd6763a619b5860fb3348e2d89183a21b7f4675cce2" => :high_sierra
    sha256 "5dc7afdb80fe5d71c8f6b7e5f589d122d6cae2b5a188187322a656d78f5022ed" => :sierra
    sha256 "9b2520f4c8c2bc7a131d3f1dc20413cf51818067516e15f620a88112bed5a647" => :el_capitan
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
