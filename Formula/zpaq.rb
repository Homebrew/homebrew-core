class Zpaq < Formula
  desc "Incremental, journaling command-line archiver"
  homepage "http://mattmahoney.net/dc/zpaq.html"
  revision 1
  head "https://github.com/zpaq/zpaq.git"

  stable do
    url "http://mattmahoney.net/dc/zpaq705.zip"
    sha256 "d8abe3e3620d4c6f3ddc1da149acffa4c24296fd9c74c9d7b62319e308b63334"
    version "7.05"

    # Should be removed once >7.05 ships as stable
    resource "backport_makefile" do
      url "http://mattmahoney.net/dc/zpaq713.zip"
      sha256 "9120cf4fb1afdecea3ac4f690d7b0577f7cb004ca6b152856edd8ac444f0d919"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "f0998826effe4dae407d041c4143a39b3645dc46a82456b4e86ac88f106babd3" => :el_capitan
    sha256 "bdd4716595b8eed1c52d2a2ef43abb095a996d05a0489f81f0b22ae43a26d51d" => :yosemite
    sha256 "a71ad4808da8c69844f72322ff7633b895d034028129b30c3d25409d91bd4213" => :mavericks
    sha256 "a2d2215b51cc18370f5ebe700160d1d7143ce5d680b2365a5adb4bb1622d06fc" => :mountain_lion
  end

  devel do
    url "http://mattmahoney.net/dc/zpaq713.zip"
    sha256 "9120cf4fb1afdecea3ac4f690d7b0577f7cb004ca6b152856edd8ac444f0d919"
    version "7.13"
  end

  resource "test" do
    url "http://mattmahoney.net/dc/calgarytest2.zpaq"
    sha256 "b110688939477bbe62263faff1ce488872c68c0352aa8e55779346f1bd1ed07e"
  end

  def install
    # Should be removed once >7.05 ships as stable
    if build.stable?
      resource("backport_makefile").stage do
        buildpath.install "Makefile"
      end
    end

    # Makefile introduced for >7.05 has not yet been adapted for OS X
    # Reported 12th May 2016 to mattmahoneyfl@gmail.com
    inreplace "Makefile" do |s|
      # Use OS X style dylib names
      s.gsub! "libzpaq.so.0.1", "libzpaq.0.1.dylib"
      s.gsub! "libzpaq.so", "libzpaq.dylib"

      # ld: unknown option: -soname
      # ld: file not found: libzpaq.0.1.dylib
      # use the correct arguments to compile a dylib
      s.gsub! "-Wl,-soname,$(SONAME) -o $@ $<",
              "-Wl -dynamiclib libzpaq.o zpaq.o -o $(SONAME)"

      # clang: error: no such file or directory: 'zpaq.o'
      # libzpaq.0.1.dylib needs both libzpaq.o and zpaq.o
      s.gsub! "$(SONAME): libzpaq.o", "$(SONAME): libzpaq.o zpaq.o"

      # OS X `install` command doesn't have `-t`
      s.gsub! /(install -m.* )-t (.*) (.*)(\r)/, "\\1 \\3 \\2\\4"
    end

    system "make"
    system "make", "check"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    resource("test").stage testpath
    assert_match /all OK/, shell_output("#{bin}/zpaq x calgarytest2.zpaq 2>&1")
  end
end
