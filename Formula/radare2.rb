class Radare2 < Formula
  desc "Reverse engineering framework"
  homepage "http://radare.org"

  stable do
    url "http://www.radare.org/get/radare2-0.10.3.tar.xz"
    sha256 "40200c9ceb42f1ef4634843249c03d9149822e690c7edfb748c88f596eb8cb93"

    resource "bindings" do
      url "http://www.radare.org/get/radare2-bindings-0.10.3.tar.xz"
      sha256 "eabc7036bd84f0df1f45d54beb1644712475993a3e9bbc48ec41e5d2a25ba1f2"
    end

    resource "extras" do
      url "http://www.radare.org/get/radare2-extras-0.10.3.tar.xz"
      sha256 "5717cc8d5da6bab6ab20a09555d6091b3ffbb50c03dd47c2a89cf1b5566ddd2d"
    end
  end

  bottle do
    sha256 "2d07896ff499ba5ef7b003a4da24ac68252499c06be265ccb964e7942d91b31e" => :el_capitan
    sha256 "6326bc1a114aab239118865467e1669c0de9137b6724b94376ab953face5f816" => :yosemite
    sha256 "fc0d35e68a13e164bfe4e48bd8a8bc2ba1dade7ecc7d1164780b0819ce9fe239" => :mavericks
  end

  head do
    url "https://github.com/radare/radare2.git"

    resource "bindings" do
      url "https://github.com/radare/radare2-bindings.git"
    end

    resource "extras" do
      url "https://github.com/radare/radare2-extras.git"
    end
  end

  depends_on "pkg-config" => :build
  depends_on "valabind" => :build
  depends_on "swig" => :build
  depends_on "gobject-introspection" => :build
  depends_on "gmp"
  depends_on "libewf"
  depends_on "libmagic"
  depends_on "lua51" # It seems to latch onto Lua51 rather than Lua. Enquire this upstream.
  depends_on "openssl"
  depends_on "yara"

  def install
    # Build Radare2 before bindings, otherwise compile = nope.
    system "./configure", "--prefix=#{prefix}", "--with-openssl"
    system "make", "CS_PATCHES=0"
    system "make", "install"

    resource("extras").stage do
      ENV.append_path "PATH", bin
      ENV.append_path "PKG_CONFIG_PATH", "#{lib}/pkgconfig"

      system "./configure", "--prefix=#{prefix}"
      system "make", "all"
      system "make", "install"
    end

    resource("bindings").stage do
      ENV.append_path "PATH", bin
      ENV.append_path "PKG_CONFIG_PATH", "#{lib}/pkgconfig"

      # Language versions.
      perl_version = `/usr/bin/perl -e 'printf "%vd", $^V;'`
      lua_version = "5.1"

      # Lazily bind to Python.
      inreplace "do-swig.sh", "VALABINDFLAGS=\"\"", "VALABINDFLAGS=\"--nolibpython\""
      make_binding_args = ["CFLAGS=-undefined dynamic_lookup"]

      # Ensure that plugins and bindings are installed in the correct Cellar
      # paths.
      inreplace "libr/lang/p/Makefile", "R2_PLUGIN_PATH=", "#R2_PLUGIN_PATH="
      inreplace "Makefile", "LUAPKG=", "#LUAPKG="
      inreplace "Makefile", "${DESTDIR}$$_LUADIR", "#{lib}/lua/#{lua_version}"
      make_install_args = ["R2_PLUGIN_PATH=#{lib}/radare2/#{version}",
                           "LUAPKG=lua-#{lua_version}",
                           "PERLPATH=#{lib}/perl5/site_perl/#{perl_version}",
                           "PYTHON_PKGDIR=#{lib}/python2.7/site-packages",
                           "RUBYPATH=#{lib}/ruby/#{RUBY_VERSION}"]

      system "./configure", "--prefix=#{prefix}"
      ["lua", "perl", "python"].each do |binding|
        system "make", "-C", binding, *make_binding_args
      end
      system "make"
      system "make", "install", *make_install_args
    end
  end

  test do
    assert_match /radare2 #{version.to_s}/, shell_output("#{bin}/r2 -version")
  end
end
