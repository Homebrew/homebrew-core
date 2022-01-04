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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9eb668c56cb2a8dde9d6090addaf8373c62321699d4a56c6eac3dab159132b5c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1fedd7f71a707d43d01afd4cdc2f7d46967c39a8dbcd9766eec40b1f5579127e"
    sha256 cellar: :any_skip_relocation, monterey:       "7d657ac4e7f65d439207e7483a45cb68d388827d1232e7fb0a5dc4b5af38011f"
    sha256 cellar: :any_skip_relocation, big_sur:        "9150fb652c97cca8531a9910d14b3ce1a056c2840f18fc7eb758d22586ff71fd"
    sha256 cellar: :any_skip_relocation, catalina:       "852d9297c293ea856bb099402f0db501822ecd8f83ce28107d026c0544b7b290"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ebce6138a8be3fe0dc816f0b6b129ab11b7223dda7451b9f53494fe7f3731c33"
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
