class Sha3sum < Formula
  desc "Keccak, SHA-3, SHAKE, and RawSHAKE checksum utilities"
  homepage "https://github.com/maandree/sha3sum"
  url "https://github.com/maandree/sha3sum/archive/1.2.1.tar.gz"
  sha256 "3ab7cecf3fbbf096ce43573f48dab9969866e8f8662beefb2777a6713891a4d9"
  license "ISC"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "90742599d666acfad990ce1247b16f12e4c7c120f2a18aacd09161f8630ef40a"
    sha256 cellar: :any, big_sur:       "6bc4ecb769628672f3d40e61986f7a581a1fc42c67fc3a27ae684cd5a9ed2c78"
    sha256 cellar: :any, catalina:      "86132112430a1b8e5b9c22ab18e0c7e9ef037bbfdb1e17739a61834bfbdc55c0"
    sha256 cellar: :any, mojave:        "f163e7452142623f7e819066f8f137d7e9b311026514bf2d8a44c7b45f4fab07"
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
