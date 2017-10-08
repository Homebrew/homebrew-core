class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://live.gnome.org/Vala"
  url "https://download.gnome.org/sources/vala/0.38/vala-0.38.2.tar.xz"
  sha256 "20d5d9c4fbd17877969dbce27e6428da67138e116b1717cc07b5b75fd6ab78a7"

  bottle do
    sha256 "47cf2afd0ae28dd89669a75f7e6ec6654a860914e70811f660ea211934021cd1" => :high_sierra
    sha256 "0ce8315e19c9f57bbea817849f420894c73195207866d2aa6075b5cbb5b5678e" => :sierra
    sha256 "abf8b5e9f4ab9df366f18d1c76c5a9244ca09ac845bce85e9a3dac35c1bc9696" => :el_capitan
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
