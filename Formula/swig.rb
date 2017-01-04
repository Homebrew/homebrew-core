class Swig < Formula
  desc "Generate scripting interfaces to C/C++ code"
  homepage "http://www.swig.org/"
  url "https://downloads.sourceforge.net/project/swig/swig/swig-3.0.11/swig-3.0.11.tar.gz"
  sha256 "d9031d531d7418829a54d0d51c4ed9007016b213657ec70be44031951810566e"

  bottle do
    sha256 "0b5ade8c002e0f28c6e6f2d7643119138a8cc75d1363809f59e042c4fb54c6b7" => :sierra
    sha256 "26124aad280aadec6e95bb3a797ca48980f2cdf442f712c58bc43d02ae794f0c" => :el_capitan
    sha256 "8811ab4b431de10f0c061f80d3c549c9b475eb8f273c7c6fd1f71e11f52bfbe8" => :yosemite
  end

  option :universal

  depends_on "pcre"

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
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
    system ENV.cc, "-bundle", "-undefined", "dynamic_lookup", "test.o", "test_wrap.o", "-o", "test.bundle"
    assert_equal "2", shell_output("ruby run.rb").strip
  end
end
