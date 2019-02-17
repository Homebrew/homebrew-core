class Tree < Formula
  desc "Display directories as trees (with optional color/HTML output)"
  homepage "http://mama.indstate.edu/users/ice/tree/"
  url "https://deb.debian.org/debian/pool/main/t/tree/tree_1.8.0.orig.tar.gz"
  sha256 "715d5d4b434321ce74706d0dd067505bb60c5ea83b5f0b3655dae40aa6f9b7c2"

  bottle do
    cellar :any_skip_relocation
    sha256 "7152288c457dd893de50fa9d6ac9a8599748564e1b3586eec8eff7057089051a" => :mojave
    sha256 "107d965994381d34e90b58a62f1c306c1b8a698db2696cdd905ba65c801ecc3b" => :high_sierra
    sha256 "07d980571469a0cc699c69a8726eee338f782ba61c041e58f01ddb2924d08aeb" => :sierra
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
