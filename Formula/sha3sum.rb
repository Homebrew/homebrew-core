class Sha3sum < Formula
  desc "Keccak, SHA-3, SHAKE, and RawSHAKE checksum utilities"
  homepage "https://github.com/maandree/sha3sum"
  url "https://github.com/maandree/sha3sum/archive/1.2.1.tar.gz"
  sha256 "3ab7cecf3fbbf096ce43573f48dab9969866e8f8662beefb2777a6713891a4d9"
  license "ISC"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "401b68d1d6ca95b27fb06ae62d5f03ea1938745976d8de1309e71b0230276e34"
    sha256 cellar: :any, big_sur:       "c1d9c795aa8919edcf17567be2dc5604561b9d5a6596d2ef1ec05051c68915e9"
    sha256 cellar: :any, catalina:      "112203983307e26b79141bd8886e4bb4e5c5f33fdd240f08d487aed870e0f004"
    sha256 cellar: :any, mojave:        "d5648273485e7cc33aa58186215b39ec7795df427cb5060643029447c8dbc8a1"
  end

  depends_on "libkeccak"

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
