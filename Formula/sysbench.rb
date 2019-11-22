class Sysbench < Formula
  desc "System performance benchmark tool"
  homepage "https://github.com/akopytov/sysbench"
  url "https://github.com/akopytov/sysbench/archive/1.0.18.tar.gz"
  sha256 "c679b285e633c819d637bdafaeacc1bec13f37da5b3357c7e17d97a71bf28cb1"
  revision 1

  bottle do
    cellar :any
    sha256 "a720824e2b028688b66f6f364d6e45754e3544001c5ab5427d9c0fc0c5e7153f" => :catalina
    sha256 "8343774a73daa156e839c23c521f5ddce1c4d12c7106028c6b78e3b10193e112" => :mojave
    sha256 "6a24f2724fd649fc96a0f6829620a46b71d8edbff172fc17d163cbaaf728a3ad" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "mysql-client"
  depends_on "openssl@1.1"

  def install
    system "./autogen.sh"

    # Fix for luajit build breakage.
    # Per https://luajit.org/install.html: If MACOSX_DEPLOYMENT_TARGET
    # is not set then it's forced to 10.4, which breaks compile on Mojave.
    # https://github.com/LuaJIT/LuaJIT/issues/518: set to 10.14 to build on Catalina.
    ENV["MACOSX_DEPLOYMENT_TARGET"] = (DevelopmentTools.clang_build_version >= 1100) ? "10.14" : MacOS.version

    system "./configure", "--prefix=#{prefix}", "--with-mysql"
    system "make", "install"
  end

  test do
    system "#{bin}/sysbench", "--test=cpu", "--cpu-max-prime=1", "run"
  end
end
