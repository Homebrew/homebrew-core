class Sysbench < Formula
  desc "System performance benchmark tool"
  homepage "https://github.com/akopytov/sysbench"
  url "https://github.com/akopytov/sysbench/archive/1.0.18.tar.gz"
  sha256 "c679b285e633c819d637bdafaeacc1bec13f37da5b3357c7e17d97a71bf28cb1"

  bottle do
    cellar :any
    sha256 "197768ce717684b1a79b69a76f3dc8f9e1e47543ba76471699871b2af0326c69" => :mojave
    sha256 "0f52b19854f9bc1a03835603e4c61b10a2aca9cfdaefb8f0cbafa7b2965fb90c" => :high_sierra
    sha256 "f49ee681ab5deb62bf7ee19424333dda2374c0a2583f7e9d3b61bf6532cde228" => :sierra
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
