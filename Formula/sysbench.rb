class Sysbench < Formula
  desc "System performance benchmark tool"
  homepage "https://github.com/akopytov/sysbench"
  url "https://github.com/akopytov/sysbench/archive/1.0.18.tar.gz"
  sha256 "c679b285e633c819d637bdafaeacc1bec13f37da5b3357c7e17d97a71bf28cb1"

  bottle do
    cellar :any
    sha256 "c3c5e3c681f8ab8d0fa65e0ab35cfeed862c5dd5100f995c898fc09c4586d05e" => :catalina
    sha256 "5e2feb16bf04b68e8e55d7151f7433ea24d9f9fbcbcd3ea9d069eb6ed47e391b" => :mojave
    sha256 "ec91591ea8d8f14cfc953dff4467c394b1230c18d96795de9d153e003c25db09" => :high_sierra
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
