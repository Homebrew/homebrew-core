class Radare2 < Formula
  desc "Reverse engineering framework"
  homepage "https://radare.org"
  url "https://github.com/radareorg/radare2/archive/refs/tags/6.0.8.tar.gz"
  sha256 "430692ae5d12531d14447b7ab4a0d83cb77e79aa18e7eae9355ea363618b779e"
  license "LGPL-3.0-only"
  head "https://github.com/radareorg/radare2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "2b187bc235433f5fcff90e7aff1c0d837ab0f0e90d884244f404a932634486b2"
    sha256 arm64_sequoia: "c853bed6715f7d8bedfc42cdcb724e3d8d56a11ab1057b46da8479edbda10911"
    sha256 arm64_sonoma:  "14312ae7222ccab5cb82b5f4297dd7869cf829011429f7e14614d831cf814b58"
    sha256 sonoma:        "d8eacff62d17c1d32f451668cc4a1762f36834d3c38a966c1550fbd803fb28a7"
    sha256 arm64_linux:   "a1179a9324baddcf8e6d8b073f6a168d298647205563da610a837d49ad0a58f5"
    sha256 x86_64_linux:  "6419cbe38eef2c331f09bff032e7f0de8f51976bab0bca316f1a13e500c42d15"
  end

  # Required for r2pm (https://github.com/radareorg/radare2-pm/issues/170)
  depends_on "pkgconf"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "radare2 #{version}", shell_output("#{bin}/r2 -v")
  end
end
