class Swig < Formula
  desc "Generate scripting interfaces to C/C++ code"
  homepage "http://www.swig.org/"
  url "https://downloads.sourceforge.net/project/swig/swig/swig-4.0.2/swig-4.0.2.tar.gz"
  sha256 "d53be9730d8d58a16bf0cbd1f8ac0c0c3e1090573168bfa151b01eb47fa906fc"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_monterey: "9e60e978ae83f0afd63aa8a27d3e418eda0cb75b89c0d22e25a0ccc5f2e00b3e"
    sha256 arm64_big_sur:  "918c070202e0138b64b2e27f262aae3a72ab9f273f14842802d1fbe9169e66fc"
    sha256 monterey:       "170414d38ab55ef50cb1275fbb0a9e0f0248ad1e23755af8ac2184a6825d514e"
    sha256 big_sur:        "f198353656b61cb35b5c28ed6c9cb10689d2a0fc69529cfbcbc0fbd75a027e27"
    sha256 catalina:       "530e80b7e7dcd28469b52fc3b668683a97b72642ebf2b6d4e6708d14f05e7286"
    sha256 mojave:         "50afb5930cb37af2e400f0369f6da15b1d4922c1f72f45d13e7e3f8bd9d6d27b"
    sha256 high_sierra:    "8bab440005b048ce454a3dd50ba608e1f85391edd73e9e40510269e923cad238"
    sha256 x86_64_linux:   "2a5fe8e40d8ba5e09fd194e9e36f8fe4bd7a427e31d1456a99bb45539074c92a"
  end

  head do
    url "https://github.com/swig/swig.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pcre"

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
