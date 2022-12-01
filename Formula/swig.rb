class Swig < Formula
  desc "Generate scripting interfaces to C/C++ code"
  homepage "http://www.swig.org/"
  url "https://downloads.sourceforge.net/project/swig/swig/swig-4.1.1/swig-4.1.1.tar.gz"
  sha256 "2af08aced8fcd65cdb5cc62426768914bedc735b1c250325203716f78e39ac9b"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_ventura:  "da2a0ed31e7c512de65131d162be610f2009518386a70f69db1b9134a94506ac"
    sha256 arm64_monterey: "80291f33f362db51985ec93db7a80a2a8efdfc377e3bec1175696707f9254a6b"
    sha256 arm64_big_sur:  "5825b5b4d280fa33d16194cce2db7a32a5bfc3f01d424027e78ccb1ef2c39274"
    sha256 ventura:        "9374e7b731037ae529d1a8449b798ef7107580c71d8f02592929d19075a9c246"
    sha256 monterey:       "dafaef7743b38de422618126d5bc9a7727c94c8e253258c8994f8aedd46f574e"
    sha256 big_sur:        "79f2d7c2d3b443d0b3a0ccaeead34da0e5d3e66963d9c14130ebe00f6f2c4a2f"
    sha256 catalina:       "c0b65fbcae8384ff3433a6b933a85faa5c1af090cbea90026b5b0cd82cc5dbce"
    sha256 x86_64_linux:   "f330831a8030b19c3f4ef25dd2b980daa343dd9119a89c736b45559170bc20a9"
  end

  head do
    url "https://github.com/swig/swig.git"

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
