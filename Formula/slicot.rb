class Slicot < Formula
  desc "Fortran 77 algorithms for computations in systems and control theory"
  homepage "http://www.slicot.org"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/s/slicot/slicot_5.0+20101122.orig.tar.gz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/s/slicot/slicot_5.0+20101122.orig.tar.gz"
  version "5.0+20101122"
  sha256 "fa80f7c75dab6bfaca93c3b374c774fd87876f34fba969af9133eeaea5f39a3d"

  depends_on "gcc"

  def install
    args = [
      "FORTRAN=#{ENV.fc}",
      "LOADER=#{ENV.fc}",
    ]
    system "make", "lib", "OPTS=-fPIC", "SLICOTLIB=../libslicot_pic.a", *args
    system "make", "clean"
    system "make", "lib", "OPTS=-fPIC -fdefault-integer-8",
           "SLICOTLIB=../libslicot64_pic.a", *args
    lib.install "libslicot_pic.a", "libslicot64_pic.a"
  end
end
