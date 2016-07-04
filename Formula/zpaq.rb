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
    cellar :any
    sha256 "701471e90f187469973d3c4d66ef017f92b5fe4026a98dddaca9503b3ac39cf2" => :el_capitan
    sha256 "646a3f4e3638da5983cf62f7ee1f8ff3146a033de749cbb8cc44f5860e155d91" => :yosemite
    sha256 "78084452d764be87e2d4e526cc9fee26a56af44318d454e233bd8d29bef3f537" => :mavericks
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
