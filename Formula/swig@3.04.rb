class SwigAT304 < Formula
  desc "Generate scripting interfaces to C/C++ code"
  homepage "http://www.swig.org/"
  url "https://downloads.sourceforge.net/project/swig/swig/swig-3.0.4/swig-3.0.4.tar.gz"
  sha256 "410ffa80ef5535244b500933d70c1b65206333b546ca5a6c89373afb65413795"

  bottle do
    sha256 "264a8dc6653c2fc3ae88f1b0a8d60aef2b54db681b4fce4ce783b4f73f6daa84" => :mojave
    sha256 "fa6edd5df156b7a985bfe6f74f56cf15682af6b01d11f0ed342f2f05444234f0" => :high_sierra
    sha256 "51b8115c0a2813caf115fb5f082e7aa1b84b7c51acec70822b8619e918969a14" => :sierra
    sha256 "84988480f25dea3fce15b6ca0e9a3322222cc473066f23626d59b20001574fdf" => :el_capitan
    sha256 "f5e5251fa5d8f6ce3a7e63c9f3762ccd3bbc49f4664d1d781b71425992c2425b" => :yosemite
  end

  keg_only :versioned_formula

  depends_on "pcre"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      int add(int x, int y)
      {
        return x + y;
      }
    EOS
    (testpath/"test.i").write <<~EOS
      %module test
      %inline %{
      extern int add(int x, int y);
      %}
    EOS
    (testpath/"run.rb").write <<~EOS
      require "./test"
      puts Test.add(1, 1)
    EOS
    system "#{bin}/swig", "-ruby", "test.i"
    system ENV.cc, "-c", "test.c"
    system ENV.cc, "-c", "test_wrap.c", "-I/System/Library/Frameworks/Ruby.framework/Headers/"
    system ENV.cc, "-bundle", "-flat_namespace", "-undefined", "suppress", "test.o", "test_wrap.o", "-o", "test.bundle"
    assert_equal "2", shell_output("/usr/bin/ruby run.rb").strip
  end
end
