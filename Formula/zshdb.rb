class Zshdb < Formula
  desc "Debugger for zsh"
  homepage "https://github.com/rocky/zshdb"
  url "https://downloads.sourceforge.net/project/bashdb/zshdb/1.1.2/zshdb-1.1.2.tar.gz"
  sha256 "bf9cb36f60ce6833c5cd880c58d6741873b33f5d546079eebcfce258d609e9af"
  license "GPL-3.0"

  # We check the "zshdb" directory page because the bashdb project contains
  # various software and zshdb releases may be pushed out of the SourceForge
  # RSS feed.
  livecheck do
    url "https://sourceforge.net/projects/bashdb/files/zshdb/"
    strategy :page_match
    regex(%r{href=(?:["']|.*?zshdb/)?v?(\d+(?:[.-]\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "388da120bb13ac218a9940ac65353776836a05a1d7b22b464d87800d5b7a8f91"
    sha256 cellar: :any_skip_relocation, big_sur:       "192eac5cebd479f637b5a0d6ea50abb908f0ab2453b570e9888a16f1c5eea1ec"
    sha256 cellar: :any_skip_relocation, catalina:      "2bdc583e95b4d4bd92624d48ce804561e3a337792dbba74f451a2507eb939704"
    sha256 cellar: :any_skip_relocation, mojave:        "2bdc583e95b4d4bd92624d48ce804561e3a337792dbba74f451a2507eb939704"
    sha256 cellar: :any_skip_relocation, high_sierra:   "2bdc583e95b4d4bd92624d48ce804561e3a337792dbba74f451a2507eb939704"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0095aa6ebce686ac4a2208a3e0dfdabd31d05d191e19dd81270621743d5e63c0"
    sha256 cellar: :any_skip_relocation, all:           "0095aa6ebce686ac4a2208a3e0dfdabd31d05d191e19dd81270621743d5e63c0"
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
