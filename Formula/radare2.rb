class Radare2 < Formula
  desc "Reverse engineering framework"
  homepage "https://radare.org"

  stable do
    url "https://radare.mikelloc.com/get/2.8.0/radare2-2.8.0.tar.gz"
    sha256 "015c0b54cbeab2f055ca45ea57675ac5fcddb9be788249143e20bb64554a769e"

    resource "bindings" do
      url "https://radare.mikelloc.com/get/2.8.0/radare2-bindings-2.8.0.tar.gz"
      sha256 "4a3b6e8101093033342e862b6834c92072bc6d902583dbca36b45a4684a4d40f"
    end

    resource "extras" do
      url "https://radare.mikelloc.com/get/2.8.0/radare2-extras-2.8.0.tar.gz"
      sha256 "f11f16faec355eddc509e3615e42b5c9de565858d68790a5c7591b6525488f75"
    end
  end

  bottle do
    sha256 "46704fec687e6ebe39a3a327814e093d472492eee840e486760b5824949558b1" => :mojave
    sha256 "cc571a80f7c88293a730172dd5b4406c084ecc05efac9cbca440657797a5da64" => :high_sierra
    sha256 "3b0f9155c6fbc2ad3c155c399726d99088dc24f41ab7bbf9522dc6ce30d5dd95" => :sierra
    sha256 "af3faa1cc55dc1deead3c6bff00222a55e2350c5f8566fb86f381c34f95c3bb0" => :el_capitan
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

  option "with-code-signing", "Codesign executables to provide unprivileged process attachment"

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build
  depends_on "swig" => :build
  depends_on "valabind" => :build

  if build.with? "code-signing"
    depends_on :codesign => [{
      :identity => "org.radare.radare2",
      :url => "https://github.com/radare/radare2/blob/master/doc/macos.md",
    }]
  end

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
    if build.with? "code-signing"
      # Brew changes the HOME directory which breaks codesign
      home = `eval printf "~$USER"`
      system "make", "HOME=#{home}", "-C", "binr/radare2", "macossign"
      system "make", "HOME=#{home}", "-C", "binr/radare2", "macos-sign-libs"
    end
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
