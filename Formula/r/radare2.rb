class Radare2 < Formula
  desc "Reverse engineering framework"
  homepage "https://radare.org"
  url "https://github.com/radareorg/radare2/archive/refs/tags/5.9.8.tar.gz"
  sha256 "e45e4fd342f04b2e00363bc1b68cc375c1cf36041085d3d59caa7a3b7be43836"
  license "LGPL-3.0-only"
  head "https://github.com/radareorg/radare2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "e1f3a925db6a3f6587bf18b42db0182e047dfd2e4a7c9bb224715fc084fe2f13"
    sha256 arm64_sonoma:  "7bb9ae6fb9e64a8be412703e661defce66bea8f0ae0b0286ff47a572ea21f1ff"
    sha256 arm64_ventura: "dfaea432a6a13e9b8a614dcf3b3011acd19e7264d545b134a31527da74c5387b"
    sha256 sonoma:        "a8077a79e428ab9ea479720de7639374bbdf27c1458ed464fb0e2cb7d6a35a94"
    sha256 ventura:       "4688b0cdaff8b2d8ab3910b8f4c40d3df69282ae89c742735e0155564ceb6e0a"
    sha256 arm64_linux:   "8cc9896896aa6f94299dae64f0e793075604f900fdb5620a1761e2254895eb6d"
    sha256 x86_64_linux:  "3945a5e9b1b47d9f11b14c44c5ccf849dcae3be42aca6f3d7b112cd8601c11f3"
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
