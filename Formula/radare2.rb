class Radare2 < Formula
  desc "Reverse engineering framework"
  homepage "https://radare.org"
  url "https://github.com/radareorg/radare2/archive/5.7.2.tar.gz"
  sha256 "09a540fe0be65f6cccb08a1f9f4dcfde03b29654c99aaf8adf9dcfcd1df1bfe5"
  license "LGPL-3.0-only"
  head "https://github.com/radareorg/radare2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_monterey: "347c1e9d352b43a3cf42cad117831c6cad8cc05570892a8f58daa9edfae50873"
    sha256 arm64_big_sur:  "72429d119cb3c1909f52fbd807285c83504027929e636712292add4d8e9e246c"
    sha256 monterey:       "a10483bf37afe6163a67a17f82130436a56f52b5ddf2ff3a57845ed9b60794d1"
    sha256 big_sur:        "68b071df16266c0c33799aa47f11ecf1f3c55ba55d0b7d73b447276cd3a9df41"
    sha256 catalina:       "03b12aa0c025e3b74b58f57ffa3b0843877dc884bb104af6389a5272ff4f8390"
    sha256 x86_64_linux:   "10fea8e577092785d2d8441e51d7575e4854ff5884035f0bb0a1e4f283fe6402"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "radare2 #{version}", shell_output("#{bin}/r2 -v")
  end
end
