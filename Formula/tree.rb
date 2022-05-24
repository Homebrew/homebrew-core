class Tree < Formula
  desc "Display directories as trees (with optional color/HTML output)"
  homepage "http://mama.indstate.edu/users/ice/tree/"
  url "http://mama.indstate.edu/users/ice/tree/src/tree-2.0.2.tgz"
  sha256 "7d693a1d88d3c4e70a73e03b8dbbdc12c2945d482647494f2f5bd83a479eeeaf"
  license "GPL-2.0-or-later"

  livecheck do
    url "http://mama.indstate.edu/users/ice/tree/src/"
    regex(/href=.*?tree[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4067f9a8f40d9bbf337272fcee99df3ad4d055ebbaf7166fed039e1bb1a45cb9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "332870d58176b70b06af057186afe0fb3168158c51ff2826222dd43fafe582b7"
    sha256 cellar: :any_skip_relocation, monterey:       "ea1c2527bde7429aef3bc634a0dc52db53616a5d1c2861f6338c5ae3f5539624"
    sha256 cellar: :any_skip_relocation, big_sur:        "e4530a4cc9024dafee21609b81b7d10649a1817c7a9c718b697b34d592e45282"
    sha256 cellar: :any_skip_relocation, catalina:       "e02fc65aff868fb5813fba17fd6e9db2fbe5ea7bbfb181a768a0f1ab9a6b7467"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1d7569f6930271d694e739e93eb026aac1e8b386ee3af8eb9aed9be32cb1865"
  end

  def install
    ENV.append "CFLAGS", "-fomit-frame-pointer"
    objs = "tree.o list.o hash.o color.o file.o filter.o info.o unix.o xml.o json.o html.o strverscmp.o"

    system "make", "PREFIX=#{prefix}",
                   "MANDIR=#{man}",
                   "CC=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "LDFLAGS=#{ENV.ldflags}",
                   "OBJS=#{objs}",
                   "install"
  end

  test do
    system "#{bin}/tree", prefix
  end
end
