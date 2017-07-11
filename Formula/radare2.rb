class CodesignRequirement < Requirement
  include FileUtils
  fatal true

  satisfy(:build_env => false) do
    mktemp do
      cp "/usr/bin/false", "radare2_check"
      quiet_system "/usr/bin/codesign", "-f", "-s", "org.radare.radare2", "--dryrun", "radare2_check"
    end
  end

  def message
    <<-EOS.undent
      org.radare.radare2 identity must be available to build with automated signing.
      See: https://github.com/radare/radare2/blob/master/doc/osx.md
    EOS
  end
end

class Radare2 < Formula
  desc "Reverse engineering framework"
  homepage "https://radare.org"

  stable do
    url "https://radare.mikelloc.com/get/1.6.0/radare2-1.6.0.tar.gz"
    sha256 "959dcac19020932983cff79a069c4467410217c941e24dd9f6d0fc0fc8d4ef99"

    resource "bindings" do
      url "https://radare.mikelloc.com/get/1.6.0/radare2-bindings-1.6.0.tar.gz"
      sha256 "abc320c4f5353f15d96a40329349253f140f0921074f0d0dbee6b3cb9f0067b8"
    end

    resource "extras" do
      url "https://radare.mikelloc.com/get/1.6.0/radare2-extras-1.6.0.tar.gz"
      sha256 "305b55d8ab85dcf5a2abe3d624e38169cd6e82c07896e85aa153ca4413a63cd2"
    end
  end

  bottle do
    sha256 "1142a0e06c2821dfcb22b82597d5c816ef651e919aaa4b6c9fd97ad565dd4161" => :sierra
    sha256 "b53dcc14175d61c058805bd89b5c3d6d961471241b1b9db3adfc87cf80ad9fdb" => :el_capitan
    sha256 "0331eca2d40eb729c3d05a6865a14a6dcd9d9287d9d63b9d15dcbda93c65d957" => :yosemite
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
      system "make", "HOME=#{home}", "-C", "binr/radare2", "osxsign"
      system "make", "HOME=#{home}", "-C", "binr/radare2", "osx-sign-libs"
    end
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
      lua_version = Formula["lua"].version.to_s.match(/\d\.\d/)

      # Lazily bind to Python.
      inreplace "do-swig.sh", "VALABINDFLAGS=\"\"", "VALABINDFLAGS=\"--nolibpython\""
      make_binding_args = ["CFLAGS=-undefined dynamic_lookup"]

      # Ensure that plugins and bindings are installed in the correct Cellar
      # paths.
      inreplace "libr/lang/p/Makefile", "R2_PLUGIN_PATH=", "#R2_PLUGIN_PATH="
      # fix build, https://github.com/radare/radare2-bindings/pull/168
      inreplace "libr/lang/p/Makefile",
      "CFLAGS+=$(shell pkg-config --cflags r_core)",
      "CFLAGS+=$(shell pkg-config --cflags r_core) -DPREFIX=\\\"${PREFIX}\\\""
      inreplace "Makefile", "LUAPKG=", "#LUAPKG="
      inreplace "Makefile", "${DESTDIR}$$_LUADIR", "#{lib}/lua/#{lua_version}"
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
    end
  end

  test do
    assert_match "radare2 #{version}", shell_output("#{bin}/r2 -version")
  end
end
