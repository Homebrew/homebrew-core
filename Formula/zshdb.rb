class Zshdb < Formula
  desc "Debugger for zsh"
  homepage "https://github.com/rocky/zshdb"
  url "https://downloads.sourceforge.net/project/bashdb/zshdb/1.1.2/zshdb-1.1.2.tar.gz"
  sha256 "bf9cb36f60ce6833c5cd880c58d6741873b33f5d546079eebcfce258d609e9af"
  license "GPL-3.0"

  # We check the "zshdb" directory page because the bashdb project contains
  # various software and zshdb releases may be pushed out of the SourceForge
  # RSS feed.
  head do
    url "https://github.com/rocky/zshdb.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  livecheck do
    url "https://sourceforge.net/projects/bashdb/files/zshdb/"
    strategy :page_match
    regex(%r{href=(?:["']|.*?zshdb/)?v?(\d+(?:[.-]\d+)+)/?["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "192eac5cebd479f637b5a0d6ea50abb908f0ab2453b570e9888a16f1c5eea1ec" => :big_sur
    sha256 "388da120bb13ac218a9940ac65353776836a05a1d7b22b464d87800d5b7a8f91" => :arm64_big_sur
    sha256 "2bdc583e95b4d4bd92624d48ce804561e3a337792dbba74f451a2507eb939704" => :catalina
    sha256 "2bdc583e95b4d4bd92624d48ce804561e3a337792dbba74f451a2507eb939704" => :mojave
    sha256 "2bdc583e95b4d4bd92624d48ce804561e3a337792dbba74f451a2507eb939704" => :high_sierra
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
