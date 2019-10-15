class Sha3sum < Formula
  desc "Keccak, SHA-3, SHAKE, and RawSHAKE checksum utilities"
  homepage "https://github.com/maandree/sha3sum"
  url "https://github.com/maandree/sha3sum/archive/1.1.5.tar.gz"
  sha256 "1a4eef5b09b7f70af1f6970840475d4735a14b4fab21937b9fd104b8606654ce"

  bottle do
    cellar :any
    sha256 "2a2d98b9289a0a98536d1d73e840fb88bd9ab430f44e914d00cf29a0879a3c72" => :catalina
    sha256 "261621253f9915637cb0e49ce33764bc7c7fa80ac54481ba897b9cfffcb82965" => :mojave
    sha256 "4042da1f6559af01943de4bca3c86b9b4b5729cae9a0cb5009b849870fb086b2" => :high_sierra
    sha256 "99c160dd3fab4dd776d940ec369b9d11e5948376755f12f8c0248a3f5ab8b223" => :sierra
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
