class Radare2 < Formula
  desc "Reverse engineering framework"
  homepage "http://radare.org"

  stable do
    url "http://www.radare.org/get/radare2-0.10.2.tar.xz"
    sha256 "1bc9ce6f5d6bec366324bc542653bba5c1b89a6980c17253ec3a1f75264beb3b"

    resource "bindings" do
      url "http://www.radare.org/get/radare2-bindings-0.10.2.tar.xz"
      sha256 "7b47919c7f3d3a4eb432df8605160c72257a324c5f9e59c890799cf527228631"
    end

    resource "extras" do
      url "http://www.radare.org/get/radare2-extras-0.10.2.tar.xz"
      sha256 "ff5fbb37d654d8672965f67b216be9f2219da4db4f380954cd7d9c55ce69232b"
    end
  end

  bottle do
    sha256 "91352f89ef50be76e78e6bd592f327c666b94d2a67946a041c88c728c739401b" => :el_capitan
    sha256 "2ee94f8af46f5c6ac63c124ca465b14ad7471602fdc3782605f1f89314b7e8e3" => :yosemite
    sha256 "263351722c084685e938e8ac1c76c89f4ca03e445a671c222d65e7c19ddf06af" => :mavericks
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
                           "RUBYPATH=#{lib}/ruby/#{RUBY_VERSION}",
      ]

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
