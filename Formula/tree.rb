class Tree < Formula
  desc "Display directories as trees (with optional color/HTML output)"
  homepage "http://mama.indstate.edu/users/ice/tree/"
  url "http://mama.indstate.edu/users/ice/tree/src/tree-2.1.0.tgz"
  sha256 "0160c535bff2b0dc6a830b9944e981e3427380f63e748da96ced7071faebabf6"
  license "GPL-2.0-or-later"

  livecheck do
    url "http://mama.indstate.edu/users/ice/tree/src/"
    regex(/href=.*?tree[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4488b659e08f179e364d7aab216a2b3ba5ca7b6fbdf6340b25d5cb82f9d144b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a7216dc9c7045dbc750c4d60f327c4576a48cde385e2644797aff03204a27707"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7197e3488411d6b4c2cdbfce381b6ec1bc1aa5f808be85184e18d50bfcc51a59"
    sha256 cellar: :any_skip_relocation, ventura:        "7c41f6adcaae20c33bc99b7692bd82ef00a4f6fc7a469b120bf392956ab5d96b"
    sha256 cellar: :any_skip_relocation, monterey:       "870fa02168b6959d6191cb6e339cfe871a95f6094e7bdce7d03bf7635ec58e92"
    sha256 cellar: :any_skip_relocation, big_sur:        "1064bfd862c2c4a33923fac8aa97de469179eaf0a963709ccc9731f4d2a37d9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "296287c122d9d2424de76e22498ca04050a08ca3ff595ed32c3ee9123c0b818f"
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
