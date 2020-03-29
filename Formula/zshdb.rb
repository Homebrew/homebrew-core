class Zshdb < Formula
  desc "Debugger for zsh"
  homepage "https://github.com/rocky/zshdb"
  url "https://downloads.sourceforge.net/project/bashdb/zshdb/1.1.2/zshdb-1.1.2.tar.gz"
  sha256 "bf9cb36f60ce6833c5cd880c58d6741873b33f5d546079eebcfce258d609e9af"

  bottle do
    cellar :any_skip_relocation
    sha256 "2bdc583e95b4d4bd92624d48ce804561e3a337792dbba74f451a2507eb939704" => :catalina
    sha256 "2bdc583e95b4d4bd92624d48ce804561e3a337792dbba74f451a2507eb939704" => :mojave
    sha256 "2bdc583e95b4d4bd92624d48ce804561e3a337792dbba74f451a2507eb939704" => :high_sierra
  end

  head do
    url "https://github.com/rocky/zshdb.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "zsh"

  def install
    system "./autogen.sh" if build.head?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-zsh=#{HOMEBREW_PREFIX}/bin/zsh"
    system "make", "install"
  end

  test do
    require "open3"
    Open3.popen3("#{bin}/zshdb -c 'echo test'") do |stdin, stdout, _|
      stdin.write "exit\n"
      assert_match(/That's all, folks/, stdout.read)
    end
  end
end
