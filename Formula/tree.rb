class Tree < Formula
  desc "Display directories as trees (with optional color/HTML output)"
  homepage "http://mama.indstate.edu/users/ice/tree/"
  url "http://mama.indstate.edu/users/ice/tree/src/tree-2.0.1.tgz"
  sha256 "e3339c5a194cf6b4080f15ec59faa3679f02d5a793b2147912fbfcfb4cdf2239"
  license "GPL-2.0-or-later"

  livecheck do
    url "http://mama.indstate.edu/users/ice/tree/src/"
    regex(/href=.*?tree[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da97488f8fe9d7a3a311c93baa359af572bb8205b422221811ac92e8eaebbfb2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9a065f2fd243640d2aecf17a13e0a1fc6d0f78c0085efb71cdecaccc844ea36c"
    sha256 cellar: :any_skip_relocation, monterey:       "c451b0055eec3e37755b4cacb9686939191f5da1e145c266e5f627fa9100ad02"
    sha256 cellar: :any_skip_relocation, big_sur:        "5703e67113f18d867c877fbb0a07eb25de574a7e1fc20be29b6a959c66a1043c"
    sha256 cellar: :any_skip_relocation, catalina:       "f568637f90da6103b445ed9c491e4d21e335cc3e2d602aa4649d30d8c0a9eec6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "831c06ebe3bd01f82ee2041c765ac2fb2903ae9b1504180f39453881cc43fa5f"
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
