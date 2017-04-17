class SwigAT2 < Formula
  desc "Generate scripting interfaces to C/C++ code"
  homepage "http://www.swig.org/"
  url "https://downloads.sourceforge.net/project/swig/swig/swig-2.0.12/swig-2.0.12.tar.gz"
  sha256 "65e13f22a60cecd7279c59882ff8ebe1ffe34078e85c602821a541817a4317f7"

  bottle do
    sha256 "d2bcb10d7da81b6815b246ec94eed894e704a2e4ba5dd52110cb12d0c46ae5bb" => :sierra
    sha256 "fee77dd978cdd05e169c0d78213b4738a103357f941e6889138e563eaafaeeb7" => :el_capitan
    sha256 "6ebea13ca3f546506190dd9b8ff06eb8b2e51a8cefac102ac9544cfc50ee2d02" => :yosemite
  end

  keg_only :versioned_formula

  depends_on "pcre"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      int add(int x, int y)
      {
        return x + y;
      }
    EOS
    (testpath/"test.i").write <<-EOS.undent
      %module test
      %inline %{
      extern int add(int x, int y);
      %}
    EOS
    (testpath/"run.rb").write <<-EOS.undent
      require "./test"
      puts Test.add(1, 1)
    EOS
    system "#{bin}/swig", "-ruby", "test.i"
    system ENV.cc, "-c", "test.c"
    system ENV.cc, "-c", "test_wrap.c", "-I/System/Library/Frameworks/Ruby.framework/Headers/"
    system ENV.cc, "-bundle", "-flat_namespace", "-undefined", "suppress", "test.o", "test_wrap.o", "-o", "test.bundle"
    assert_equal "2", shell_output("ruby run.rb").strip
  end
end
