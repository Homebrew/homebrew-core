class Tree < Formula
  desc "Display directories as trees (with optional color/HTML output)"
  homepage "http://mama.indstate.edu/users/ice/tree/"
  url "https://deb.debian.org/debian/pool/main/t/tree/tree_1.8.0.orig.tar.gz"
  sha256 "715d5d4b434321ce74706d0dd067505bb60c5ea83b5f0b3655dae40aa6f9b7c2"
  license "GPL-2.0"

  livecheck do
    url "http://mama.indstate.edu/users/ice/tree/src/"
    regex(/href=.*?tree[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef081c81d87232951eff9f5bed6a589dbe3bd2b16f59e7ae28fdcc5351882429"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b9d1925b5b306e098ff43f1ce5fc409b759c6d2d468e20af5628797a56234c4f"
    sha256 cellar: :any_skip_relocation, monterey:       "5ae7d4a3a554b576bba0686789e10917f7a836028d3c3343e7752e715aa91df5"
    sha256 cellar: :any_skip_relocation, big_sur:        "572adeaba1ffee7fa8bcad414c8b18140c367bbc81dc2ab8fd438cbd7e4a985b"
    sha256 cellar: :any_skip_relocation, catalina:       "18f7984bdbab22251e9fc3c7832dbace5c7f7a77e8d63717bb0078385e2bf255"
    sha256 cellar: :any_skip_relocation, mojave:         "7152288c457dd893de50fa9d6ac9a8599748564e1b3586eec8eff7057089051a"
    sha256 cellar: :any_skip_relocation, high_sierra:    "107d965994381d34e90b58a62f1c306c1b8a698db2696cdd905ba65c801ecc3b"
    sha256 cellar: :any_skip_relocation, sierra:         "07d980571469a0cc699c69a8726eee338f782ba61c041e58f01ddb2924d08aeb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02fb3aeb2c166a65c03a92641d05b553f963d4b0cecbf1f67c1eb8a0ba95a673"
  end

  def install
    ENV.append "CFLAGS", "-fomit-frame-pointer"
    objs = "tree.o unix.o html.o xml.o json.o hash.o color.o file.o strverscmp.o"

    system "make", "prefix=#{prefix}",
                   "MANDIR=#{man1}",
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
