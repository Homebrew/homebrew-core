class Zshdb < Formula
  desc "Debugger for zsh"
  homepage "https://github.com/rocky/zshdb"
  url "https://downloads.sourceforge.net/project/bashdb/zshdb/1.1.3/zshdb-1.1.3.tar.gz"
  sha256 "10cfb5ffbf4bea82a0be2b262aed88c5b15966b77ae986c7d88f50c25778f77b"
  license "GPL-3.0"

  # We check the "zshdb" directory page because the bashdb project contains
  # various software and zshdb releases may be pushed out of the SourceForge
  # RSS feed.
  livecheck do
    url "https://sourceforge.net/projects/bashdb/files/zshdb/"
    regex(%r{href=(?:["']|.*?zshdb/)?v?(\d+(?:[.-]\d+)+)/?["' >]}i)
    strategy :page_match
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cd141e76881226d00c069ea1ae725e69d836ec2f7413713d421bcd616ac2390d"
  end

  head do
    url "https://github.com/rocky/zshdb.git", branch: "master"
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
