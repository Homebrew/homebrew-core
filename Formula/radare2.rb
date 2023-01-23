class Radare2 < Formula
  desc "Reverse engineering framework"
  homepage "https://radare.org"
  url "https://github.com/radareorg/radare2/archive/5.8.2.tar.gz"
  sha256 "5eda401bc67e8753ced9813bd66e657d86e56286abe168c12e92edc7dfdb7dbe"
  license "LGPL-3.0-only"
  head "https://github.com/radareorg/radare2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "b368aef2b6d918e2345d9c60f1bf5c2d49dc8196b60c0859641095187e037ac6"
    sha256 arm64_monterey: "4cf6731f2a03a288fbcc5bd2217609726ce44f1258abd4dc3d61a62fe59a5f28"
    sha256 arm64_big_sur:  "d3bd7e7b13f6ecc889e9adf456633c94a8ad065e1abd0af3ebf6efb3c6363ccf"
    sha256 ventura:        "23d4555d860be6fcabb8aaa69720765e7b41f15b53e52aba6b1f78416f9de60a"
    sha256 monterey:       "a8c506699259eec751f04e402827b4310368b4ea0cf92cbfd585e3b496b2e417"
    sha256 big_sur:        "0d6e424411c12fab6d103d2a56f350e94bed57672341087c9fe06653e75bac42"
    sha256 x86_64_linux:   "acdaf010ee4390e4d0e545eeb62bb6539b13a5dbb3e744e0792d12dea008e96d"
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
