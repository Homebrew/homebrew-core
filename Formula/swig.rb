class Swig < Formula
  desc "Generate scripting interfaces to C/C++ code"
  homepage "http://www.swig.org/"
  url "https://downloads.sourceforge.net/project/swig/swig/swig-3.0.12/swig-3.0.12.tar.gz"
  sha256 "7cf9f447ae7ed1c51722efc45e7f14418d15d7a1e143ac9f09a668999f4fc94d"

  bottle do
    sha256 "7307b4ffe3222715b2206e6477c5e3022881a730eb95a717d41a3df8e6e20455" => :mojave
    sha256 "c0e2656fd10d57281280d20ce8bf9a060cf8714f4283dd1dfde383b3688d9ed1" => :high_sierra
    sha256 "68cb1b6bc898f2a1bd39ae24dd0235f68ffa56d04ba8cd4424835335202977d1" => :sierra
    sha256 "37bf242aad0c18317cdaef66218483c04fa57e091b7c7f9d72089f5002881338" => :el_capitan
    sha256 "3443dbf17f78be0cecb5419772c71bb418caa91763590072224c196a57317717" => :yosemite
  end

  head do
    url "https://github.com/swig/swig.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pcre"

  def install
    system "./autogen.sh" if build.head?
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
    system ENV.cc, "-bundle", "-undefined", "dynamic_lookup", "test.o", "test_wrap.o", "-o", "test.bundle"
    assert_equal "2", shell_output("/usr/bin/ruby run.rb").strip
  end
end
