class SwigAT3 < Formula
  desc "Generate scripting interfaces to C/C++ code"
  homepage "http://www.swig.org/"
  url "https://downloads.sourceforge.net/project/swig/swig/swig-3.0.12/swig-3.0.12.tar.gz"
  sha256 "7cf9f447ae7ed1c51722efc45e7f14418d15d7a1e143ac9f09a668999f4fc94d"

  bottle do
    sha256 arm64_ventura:  "9749ef0bbccfff848f95c309c44fc1b631e725f464cf2bdcc53d1b603d874f3f"
    sha256 arm64_monterey: "f80bcd7727b999a42e672f9424b304cc5e6d801201baeddb6a6b9d4a4a7d4fe1"
    sha256 arm64_big_sur:  "233ac5b77d2e887d5d63f965897d0375101ef2ab16fd87e631e67030f553be06"
    sha256 ventura:        "101fa82e79e21d2ecc67e03754d941a583effd069477c94b4fb54be64d1f268e"
    sha256 monterey:       "5546732b5a67d9cc7e71adde37ab80a84e98a357afe9ee21fd978927dddbe911"
    sha256 big_sur:        "d0d9561bf105072f30a93f3914d05d58422f13c578de51f760e3822405dd5c36"
    sha256 catalina:       "f50becfc883397db62530bab927dcf4b5a4db5f0bcbb2839d5ac795fb924c586"
    sha256 mojave:         "28e5c0a5e8aac0c0d5f58e4dd69c590f57d3a450d92aa35b18aee037ab7d8b60"
    sha256 high_sierra:    "730bd728981cc1534664ef35d08d0b285e79756c286913d868af6afa43f60f4d"
    sha256 sierra:         "23275971784bb9272a734f44c9689dafecd5e6c4be917cd3d621064858cd76db"
    sha256 x86_64_linux:   "8ba7debca7e99a4b12be8eef984ef4bf0826ad37baf171cd2ce36e55f23ee3da"
  end

  keg_only :versioned_formula

  deprecate! date: "2022-03-01", because: :unsupported

  depends_on "pcre"

  uses_from_macos "ruby" => :test

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
    if OS.mac?
      system ENV.cc, "-c", "test.c"
      system ENV.cc, "-c", "test_wrap.c",
             "-I#{MacOS.sdk_path}/System/Library/Frameworks/Ruby.framework/Headers/"
      system ENV.cc, "-bundle", "-undefined", "dynamic_lookup", "test.o",
             "test_wrap.o", "-o", "test.bundle"
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
