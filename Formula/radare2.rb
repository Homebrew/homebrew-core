class Radare2 < Formula
  desc "Reverse engineering framework"
  homepage "https://radare.org"
  revision 1

  stable do
    url "http://radare.mikelloc.com/get/3.3.0/radare2-3.3.0.tar.gz"
    sha256 "e3971122a88fb9e8707c5f675e96e4a300a9dd83eae833b28549a09038b2ac76"

    resource "bindings" do
      url "http://radare.mikelloc.com/get/3.3.0/radare2-bindings-3.3.0.tar.gz"
      sha256 "7e680cfb735ea874c03bf9e5ed97e0d3b610c64f80a8e1c0d67d04e2f0f36df2"
    end

    resource "extras" do
      url "http://radare.mikelloc.com/get/3.3.0/radare2-extras-3.3.0.tar.gz"
      sha256 "2f72918c1f1d97c30037153468cd3a61b9b0418bb5e3b1c5da3a3242e749ad04"
    end
  end

  bottle do
    sha256 "2e54078d5cff62cd5593ba2390a0f230e334b94024954e5b6329d52c0401aafc" => :mojave
    sha256 "18dad4749aba2e1d3b5ecb55a1b3c55656bf0e604fc6e739b45a249809053a98" => :high_sierra
    sha256 "67705968143b7235843ad4a494ffca8bbfb886168656a4171bb730dec615a0d2" => :sierra
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

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build
  depends_on "swig" => :build
  depends_on "valabind" => :build

  depends_on "gmp"
  depends_on "jansson"
  depends_on "libewf"
  depends_on "libmagic"
  depends_on "lua"
  depends_on "openssl"
  depends_on "yara"

  def install
    # Build Radare2 before bindings, otherwise compile = nope.
    system "./configure", "--prefix=#{prefix}", "--with-openssl"
    system "make", "CS_PATCHES=0"
    ENV.deparallelize { system "make", "install" }

    # remove leftover symlinks
    # https://github.com/radare/radare2/issues/8688
    rm_f bin/"r2-docker"
    rm_f bin/"r2-indent"

    resource("extras").stage do
      ENV.append_path "PATH", bin
      ENV.append_path "PKG_CONFIG_PATH", "#{lib}/pkgconfig"
      (lib/"radare2/#{version}").mkpath

      system "./configure", "--prefix=#{prefix}"
      system "make", "R2PM_PLUGDIR=#{lib}/radare2/#{version}", "all"
      system "make", "R2PM_PLUGDIR=#{lib}/radare2/#{version}", "install"
    end

    resource("bindings").stage do
      ENV.append_path "PATH", bin
      ENV.append_path "PKG_CONFIG_PATH", "#{lib}/pkgconfig"

      # Language versions.
      perl_version = `/usr/bin/perl -e 'printf "%vd", $^V;'`
      lua_version = Formula["lua"].version.to_s.match(/\d\.\d/)

      # Lazily bind to Python.
      inreplace "do-swig.sh", "VALABINDFLAGS=\"\"", "VALABINDFLAGS=\"--nolibpython\""
      make_binding_args = ["CFLAGS=-undefined dynamic_lookup"]

      # Ensure that plugins and bindings are installed in the Cellar.
      inreplace "libr/lang/p/Makefile" do |s|
        s.gsub! "R2_PLUGIN_PATH=", "#R2_PLUGIN_PATH="
        s.gsub! "~/.config/radare2/plugins", "#{lib}/radare2/#{version}"
      end

      # We don't want to place json.lua in lib/lua/#{lua_version} because
      # the name is very generic, which introduces a strong possibility of
      # clashes with other formulae or in general usage.
      inreplace "libr/lang/p/lua.c",
                'os.getenv(\"HOME\")..\"/.config/radare2/plugins/lua/?.lua;',
                "\\\"#{libexec}/lua/#{lua_version}/?.lua;"

      # Really the Lua libraries should be dumped in libexec too but
      # since they're named fairly specifically it's semi-acceptable.
      inreplace "Makefile" do |s|
        s.gsub! "LUAPKG=", "#LUAPKG="
        s.gsub! "${DESTDIR}$$_LUADIR", "#{lib}/lua/#{lua_version}"
        s.gsub! "ls lua/*so*$$_LUAVER", "ls lua/*so"
      end

      make_install_args = %W[
        R2_PLUGIN_PATH=#{lib}/radare2/#{version}
        LUAPKG=lua-#{lua_version}
        PERLPATH=#{lib}/perl5/site_perl/#{perl_version}
        PYTHON_PKGDIR=#{lib}/python2.7/site-packages
        RUBYPATH=#{lib}/ruby/#{RUBY_VERSION}
      ]

      system "./configure", "--prefix=#{prefix}"
      ["lua", "perl", "python"].each do |binding|
        system "make", "-C", binding, *make_binding_args
      end
      system "make"
      system "make", "install", *make_install_args

      # This should be being handled by the Makefile but for some reason
      # it doesn't want to work. If this ever breaks it's likely because
      # the Makefile has started functioning as expected & placing it in lib.
      (libexec/"lua/#{lua_version}").install Dir["libr/lang/p/lua/*.lua"]
    end
  end

  test do
    assert_match "radare2 #{version}", shell_output("#{bin}/r2 -version")
  end
end
