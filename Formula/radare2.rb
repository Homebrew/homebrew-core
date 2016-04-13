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
    sha256 "73a42da677ce0d4fb4b02608659ff06096aa20909e8eec49cfd34904947c8728" => :el_capitan
    sha256 "348343ac295621bb2288a9d8a418ce0a55a3fea4c445703b5697a02407d6ef65" => :yosemite
    sha256 "2cf435b70d3ba0960a4f67190c472bffcdf247760cfdc3a58286b0336fed943b" => :mavericks
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
