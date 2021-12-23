class Tree < Formula
  desc "Display directories as trees (with optional color/HTML output)"
  homepage "http://mama.indstate.edu/users/ice/tree/"
  url "http://mama.indstate.edu/users/ice/tree/src/tree-2.0.0.tgz"
  sha256 "782cd73179f65cfca7f29326f1511306e49e9b11d5b861daa57e13fd7262889f"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url "http://mama.indstate.edu/users/ice/tree/src/"
    regex(/href=.*?tree[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5ec4b35d3cff75d0fe5a7edf69b7ac6ef2d1dfe2b87112176bb335cdc120fe0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3ed9a5ac8f1cc73ca42582e8ff6543bc64ef866f64b5c770f20e43303a44c5da"
    sha256 cellar: :any_skip_relocation, monterey:       "21e1c389dcaf1d26017ed7bda168a9b8bff48536b9a86470d73849e19613cff6"
    sha256 cellar: :any_skip_relocation, big_sur:        "49f1ca02e7c5dd44484e0f1634140edc3727275c5bb96985724c0ed92ff82afc"
    sha256 cellar: :any_skip_relocation, catalina:       "ec363b35861399e10a9c5bd2f9916c0239c0be663d44193b741e76cbdd2fa865"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e1e719ff353538ef037aaf22f0da6182efa166acc4e4ddbd714717e49f58202"
  end

  def install
    ENV.append "CFLAGS", "-fomit-frame-pointer"
    objs = "tree.o list.o hash.o color.o file.o filter.o info.o unix.o xml.o json.o html.o strverscmp.o"

    system "make", "prefix=#{prefix}",
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
