class Sha3sum < Formula
  desc "Keccak, SHA-3, SHAKE, and RawSHAKE checksum utilities"
  homepage "https://github.com/maandree/sha3sum"
  url "https://github.com/maandree/sha3sum/archive/1.2.2.tar.gz"
  sha256 "57cfda5d9d16aa14c78d278b1c14fd9f3504424ee62bc18137ce6435c1364d12"
  license "ISC"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a71bf2beb54a0ec5ef6defe1651d404239b16aa724cfc11e56c7a479dd5afd45"
    sha256 cellar: :any,                 arm64_big_sur:  "6a982032346aa17ceb4d050e6dd1334a4428039883036758e514f14d6c9b2c6c"
    sha256 cellar: :any,                 monterey:       "3db74567332ebcf2abe80d544df93b937bdff3ff4a593491265c647c23926aae"
    sha256 cellar: :any,                 big_sur:        "96f9780c5cb6ee06dbcca4b28eabbc7e92a4ae705db98a3f3ab66366280f1200"
    sha256 cellar: :any,                 catalina:       "23d79754d2579e0ea0bd2757dbf6f8f47ae2f093dfa54f4869e437f7ee0ab73a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9eff34d53d4a0f794bcd8303ad66ff23056a1a3f89b56bf737dae3689e5cb6f4"
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
