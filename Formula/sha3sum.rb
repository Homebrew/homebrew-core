class Sha3sum < Formula
  desc "Keccak, SHA-3, SHAKE, and RawSHAKE checksum utilities"
  homepage "https://github.com/maandree/sha3sum"
  url "https://github.com/maandree/sha3sum/archive/1.2.tar.gz"
  sha256 "e3c10938ed3e8218e17f3ab69daf2df958d97ca9a263003f0e890bc17c783787"
  license "ISC"

  bottle do
    cellar :any
    sha256 "45f7cdbaa21efa036f108869e7195a99fa825656406290863d53160a66802fde" => :big_sur
    sha256 "2a2d98b9289a0a98536d1d73e840fb88bd9ab430f44e914d00cf29a0879a3c72" => :catalina
    sha256 "261621253f9915637cb0e49ce33764bc7c7fa80ac54481ba897b9cfffcb82965" => :mojave
    sha256 "4042da1f6559af01943de4bca3c86b9b4b5729cae9a0cb5009b849870fb086b2" => :high_sierra
    sha256 "99c160dd3fab4dd776d940ec369b9d11e5948376755f12f8c0248a3f5ab8b223" => :sierra
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
