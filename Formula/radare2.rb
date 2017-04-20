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
    url "http://cloud.radare.org/get/1.4.0/radare2-1.4.0.tar.gz"
    sha256 "bf6e9ad94fd5828d3936563b8b13218433fbf44231cacfdf37a7312ae2b3e93e"

    resource "bindings" do
      url "http://cloud.radare.org/get/1.4.0/radare2-bindings-1.4.0.tar.gz"
      sha256 "0abd4c854db4932cf16d6b044ac11382f63b97779f9c5bea9167d6be1e14391c"
    end

    resource "extras" do
      url "http://cloud.radare.org/get/1.4.0/radare2-extras-1.4.0.tar.gz"
      sha256 "919bd7a3cac075f83a788ef676b4735f0e31ecd7ef97d9949f78cadeb61099aa"
    end

    resource "bindings-1.4.0-patch" do
      url "https://github.com/radare/radare2-bindings/commit/ece587c44a434254c2f09ff200d519a4010841d1.diff"
      sha256 "3f46fbd90f6aa453d89cb8d8dc4f516dc229226cdebcdefae3ac7b55aa83a864"
    end
  end

  bottle do
    sha256 "1375576749f424a8dc5bdc7fb6ee33bb69e6aa3616a19485ca8bdddcbfb31f4e" => :sierra
    sha256 "4e4d174472f126e9914dce0ca3848ce2b3448cde908bb02c0dfef65465cd9431" => :el_capitan
    sha256 "1ee3c65d01c5d2496cd6b2354675fae11bf9a9f093538663f51ed21497db8eb3" => :yosemite
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
      lua_version = Utils.popen_read("lua -v 2>&1").match(/%r{5\.\d}/)

      # Lazily bind to Python.
      inreplace "do-swig.sh", "VALABINDFLAGS=\"\"", "VALABINDFLAGS=\"--nolibpython\""
      make_binding_args = ["CFLAGS=-undefined dynamic_lookup"]

      # Ensure that plugins and bindings are installed in the correct Cellar
      # paths.
      inreplace "libr/lang/p/Makefile", "R2_PLUGIN_PATH=", "#R2_PLUGIN_PATH="
      inreplace "Makefile", "LUAPKG=", "#LUAPKG="
      inreplace "Makefile", "${DESTDIR}$$_LUADIR", "#{lib}/lua/#{lua_version}"
      # Fix for Makefile error, fixed in next release
      Pathname.pwd.install resource("bindings-1.4.0-patch")
      system "patch", "-p1", "-i", "ece587c44a434254c2f09ff200d519a4010841d1.diff"
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
