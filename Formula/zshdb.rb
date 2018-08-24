class Zshdb < Formula
  desc "Debugger for zsh"
  homepage "https://github.com/rocky/zshdb"

  stable do
    url "https://downloads.sourceforge.net/project/bashdb/zshdb/0.92/zshdb-0.92.tar.bz2"
    sha256 "faeb75dc12f4eafff195af103fde4fc5aabc258b7ed902b1aad6d4659f3ae744"

    # Fix compilation with zsh >= 5.3
    # Remove in next release
    patch do
      url "https://github.com/rocky/zshdb/commit/94b389a3.patch?full_index=1"
      sha256 "be5d4184dbc51570208fa169d6098e378b513cc699d3e2aa3f2d3bb422216995"
    end
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "71e90ca151485ad4d11a8b670a2f6abf09b56fdfad6a8e015e80bb8d8e643ba5" => :mojave
    sha256 "1cb2482a1e326d2849d1692a871704aafdf2fec05cffd0d22d2193cc1da07caf" => :high_sierra
    sha256 "1cb2482a1e326d2849d1692a871704aafdf2fec05cffd0d22d2193cc1da07caf" => :sierra
    sha256 "1cb2482a1e326d2849d1692a871704aafdf2fec05cffd0d22d2193cc1da07caf" => :el_capitan
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
