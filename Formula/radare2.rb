class Radare2 < Formula
  desc "Reverse engineering framework"
  homepage "https://radare.org"
  url "https://github.com/radareorg/radare2/archive/5.6.4.tar.gz"
  sha256 "00901cb2b80c86a03509024e42c45a1d6797ff8fe5face64e4fc03f3c299730e"
  license "LGPL-3.0-only"
  head "https://github.com/radareorg/radare2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_monterey: "6c542e77cba46225c0770a0713ca43ef093eae9a733ee6add71a9d96fb804c45"
    sha256 arm64_big_sur:  "de7363dc5df1ef1f94b9f4624250061b101761ea79ad9fe827198d713a4e735e"
    sha256 monterey:       "e122a0cd39ceb6b6404d3fedfa2ef69e7f25f13a3b5503d97b20826cb287a3c0"
    sha256 big_sur:        "f046007f2b9f14be358094c87d452e0bbca6a9865a2a62a3f92810a054e0daa8"
    sha256 catalina:       "c819b3c6a5d5685c9c743061e3d91c161f84a758e8e78d088eafb4f07dbe04a8"
    sha256 x86_64_linux:   "71786fe41cbfdaabf12ddb54cdbe001ef853471034c9d7ed7cf548ceec055d0d"
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
