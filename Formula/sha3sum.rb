class Sha3sum < Formula
  desc "Keccak, SHA-3, SHAKE, and RawSHAKE checksum utilities"
  homepage "https://github.com/maandree/sha3sum"
  url "https://github.com/maandree/sha3sum/archive/1.2.tar.gz"
  sha256 "e3c10938ed3e8218e17f3ab69daf2df958d97ca9a263003f0e890bc17c783787"
  license "ISC"

  bottle do
    cellar :any
    sha256 "c1d9c795aa8919edcf17567be2dc5604561b9d5a6596d2ef1ec05051c68915e9" => :big_sur
    sha256 "401b68d1d6ca95b27fb06ae62d5f03ea1938745976d8de1309e71b0230276e34" => :arm64_big_sur
    sha256 "112203983307e26b79141bd8886e4bb4e5c5f33fdd240f08d487aed870e0f004" => :catalina
    sha256 "d5648273485e7cc33aa58186215b39ec7795df427cb5060643029447c8dbc8a1" => :mojave
  end

  depends_on "libkeccak"

  # remove in next release
  patch do
    url "https://github.com/maandree/sha3sum/commit/d01c03c.patch?full_index=1"
    sha256 "c958d05b67330291c3d14608d1566351e05f23cf3f4fb27186e5e99765ab7dd0"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
    inreplace "test", "./", "#{bin}/"
    pkgshare.install "test"
  end

  test do
    cp_r pkgshare/"test", testpath
    system "./test"
  end
end
