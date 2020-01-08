class Zshdb < Formula
  desc "Debugger for zsh"
  homepage "https://github.com/rocky/zshdb"
  url "https://downloads.sourceforge.net/project/bashdb/zshdb/1.0.1/zshdb-1.0.1.tar.gz"
  sha256 "0b2717c1b1682b87c9e2a4d5303a5a60f9fbf418dbb7dd64fc814fbeead6506a"

  bottle do
    cellar :any_skip_relocation
    sha256 "02c72baac9b416aef9b58d98d72b1e0dca18de16efd3ae9dfd43368b52fa88a7" => :catalina
    sha256 "02c72baac9b416aef9b58d98d72b1e0dca18de16efd3ae9dfd43368b52fa88a7" => :mojave
    sha256 "02c72baac9b416aef9b58d98d72b1e0dca18de16efd3ae9dfd43368b52fa88a7" => :high_sierra
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
