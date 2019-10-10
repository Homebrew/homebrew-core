class Zshdb < Formula
  desc "Debugger for zsh"
  homepage "https://github.com/rocky/zshdb"
  url "https://downloads.sourceforge.net/project/bashdb/zshdb/1.0.1/zshdb-1.0.1.tar.gz"
  sha256 "0b2717c1b1682b87c9e2a4d5303a5a60f9fbf418dbb7dd64fc814fbeead6506a"

  bottle do
    cellar :any_skip_relocation
    sha256 "01ec9d4e145a8baa08d28b9fe2d7b5b8ac23dbcd18c7418cd0255192da314bf1" => :mojave
    sha256 "01ec9d4e145a8baa08d28b9fe2d7b5b8ac23dbcd18c7418cd0255192da314bf1" => :high_sierra
    sha256 "5deb4b52890ad39981494b708b30f184fa7ec66c95528d93468c6bcb3b93bc91" => :sierra
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
