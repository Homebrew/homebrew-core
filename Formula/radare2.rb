class CodesignRequirement < Requirement
  fatal true

  satisfy(:build_env => false) do
    mktemp do
      FileUtils.cp "/usr/bin/false", "radare2_check"
      quiet_system "/usr/bin/codesign", "-f", "-s", "org.radare.radare2", "--dryrun", "radare2_check"
    end
  end

  def message
    <<~EOS
      org.radare.radare2 identity must be available to build with automated signing.
      See: https://github.com/radare/radare2/blob/master/doc/macos.md
    EOS
  end
end

class Radare2 < Formula
  desc "Reverse engineering framework"
  homepage "https://radare.org"
  revision 1

  stable do
    url "https://radare.mikelloc.com/get/2.7.0/radare2-2.7.0.tar.gz"
    sha256 "d89c86b764edb06acb1cf0e70bdceb15dcbd7f4df551e856b471c03b34063ba3"

    resource "bindings" do
      url "https://radare.mikelloc.com/get/2.7.0/radare2-bindings-2.7.0.tar.gz"
      sha256 "df9537fd4b1bc0474fa4abba1c87687239003c047987e155ec1483a0ce988d0f"
    end

    resource "extras" do
      url "https://radare.mikelloc.com/get/2.7.0/radare2-extras-2.7.0.tar.gz"
      sha256 "c972afb865fd69b3fd2c4d6c4e6810df875a67842497efd930e6a8e49cef6f3c"
    end
  end

  bottle do
    sha256 "307a86cb27d50eb763874a3e340b29445c808c0f7be35c98fef193cc440daa67" => :high_sierra
    sha256 "eca592b689222d8d87eb8a26a5b8f9f323674862b4e1f3445c6a649d5a85f722" => :sierra
    sha256 "b3f10210028c95915b6f12887c5fade64b437160200a782688140bb6a4d2e296" => :el_capitan
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

  depends_on "pkg-config" => :build
  depends_on "valabind" => :build
  depends_on "swig" => :build
  depends_on "gobject-introspection" => :build
  depends_on "gmp"
  depends_on "jansson"
  depends_on "libewf"
  depends_on "libmagic"
  depends_on "lua"
  depends_on "openssl"
  depends_on "yara"

  depends_on CodesignRequirement if build.with? "code-signing"

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
