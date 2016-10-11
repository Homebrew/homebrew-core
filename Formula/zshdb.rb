class Zshdb < Formula
  desc "Debugger for zsh"
  homepage "https://github.com/rocky/zshdb"
  url "https://downloads.sourceforge.net/project/bashdb/zshdb/0.92/zshdb-0.92.tar.bz2"
  sha256 "faeb75dc12f4eafff195af103fde4fc5aabc258b7ed902b1aad6d4659f3ae744"

  bottle do
    cellar :any_skip_relocation
    sha256 "3b1a4a420b1e74938b673bf38e20b471417f035407bf019fa6c89e41da108359" => :sierra
    sha256 "3be3a69734982ccbed4285dc8821483c8ababe00bba9f0bd1cb54252ba772107" => :el_capitan
    sha256 "aacaceab10fb77097c1c25ae87c68f422ead071b333242b085126aaa6560638f" => :yosemite
    sha256 "0b41e171d32a9cfe1d3293fe18263f30af64cfaabfe551c09fa46d1c55cd1c0c" => :mavericks
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
