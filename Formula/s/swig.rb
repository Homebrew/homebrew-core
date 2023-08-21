class Swig < Formula
  desc "Generate scripting interfaces to C/C++ code"
  homepage "https://www.swig.org/"
  url "https://downloads.sourceforge.net/project/swig/swig/swig-4.1.1/swig-4.1.1.tar.gz"
  sha256 "2af08aced8fcd65cdb5cc62426768914bedc735b1c250325203716f78e39ac9b"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_ventura:  "360d6e5438f0ac5a819ce2f9a0812dd9fa4d8c6edec7ac7377d2717779e26bb6"
    sha256 arm64_monterey: "27c89aff26a1b22f1f645298992fba5db8d70b71772509f75870eefd7382e2e8"
    sha256 arm64_big_sur:  "d939f6eeeb6f58e3057fd311362b9e37fa969b83f6654752f5d3749898e99b69"
    sha256 ventura:        "f478fa16ba778eac8227fe51844909db95887153f6fbb8ee4e050dbb0c4acc8e"
    sha256 monterey:       "7762910a737820dc734b089253c2f5bc7140673a2300acd97f0338ebc7ef6fd5"
    sha256 big_sur:        "8133b566757d1d2295bb38d77a536258aef56b9f6b15ec3c222ff1166d596204"
    sha256 x86_64_linux:   "debb12256fb29f493afb450dddae5d66010faf0b014f719f3c530167b1b1d7a4"
  end

  head do
    url "https://github.com/swig/swig.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pcre2"

  uses_from_macos "ruby" => :test

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
    if OS.mac?
      system ENV.cc, "-c", "test.c"
      system ENV.cc, "-c", "test_wrap.c", "-I#{MacOS.sdk_path}/System/Library/Frameworks/Ruby.framework/Headers/"
      system ENV.cc, "-bundle", "-undefined", "dynamic_lookup", "test.o", "test_wrap.o", "-o", "test.bundle"
    else
      ruby = Formula["ruby"]
      args = Utils.safe_popen_read(
        ruby.opt_bin/"ruby", "-e", "'puts RbConfig::CONFIG[\"LIBRUBYARG\"]'"
      ).chomp
      system ENV.cc, "-c", "-fPIC", "test.c"
      system ENV.cc, "-c", "-fPIC", "test_wrap.c",
             "-I#{ruby.opt_include}/ruby-#{ruby.version.major_minor}.0",
             "-I#{ruby.opt_include}/ruby-#{ruby.version.major_minor}.0/x86_64-linux/"
      system ENV.cc, "-shared", "test.o", "test_wrap.o", "-o", "test.so",
             *args.delete("'").split
    end
    assert_equal "2", shell_output("ruby run.rb").strip
  end
end
