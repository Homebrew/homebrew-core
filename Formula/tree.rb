class Tree < Formula
  desc "Display directories as trees (with optional color/HTML output)"
  homepage "http://mama.indstate.edu/users/ice/tree/"
  url "http://mama.indstate.edu/users/ice/tree/src/tree-1.8.0.tgz"
  sha256 "715d5d4b434321ce74706d0dd067505bb60c5ea83b5f0b3655dae40aa6f9b7c2"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "a6f52904af4d3a3096f465b9f5b0cc778b98655da0298699b39d593c5eafa9fd" => :mojave
    sha256 "1a9ac89dc194918786c3175bdf439e74d16f7d27bd5fa4be7b006e5d0b077a1e" => :high_sierra
    sha256 "f7c8a080435445e17c254ca53b016d9012bf768851df67c3d892ba71fe98e924" => :sierra
    sha256 "2721bafcbe1db12e444f5025bdae81aa3c7cff6572aa7423e401baeb10a43157" => :el_capitan
    sha256 "c1ad4f32c4922cbd1e37aa55b8fa6e0cc8a04c96a24f0d9e7957b50b311d854d" => :yosemite
    sha256 "0bcb8a1de3ed51295917d6dd997ea492048f90a5ee1084676171a39dbd489654" => :mavericks
    sha256 "c3bd091797c487bb1ac5586d0e524da341c6043b0298269a9ded271646274fa3" => :mountain_lion
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
