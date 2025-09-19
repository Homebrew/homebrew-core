class Radare2 < Formula
  desc "Reverse engineering framework"
  homepage "https://radare.org"
  url "https://github.com/radareorg/radare2/archive/refs/tags/6.0.2.tar.gz"
  sha256 "5879969ca502fff91ec255cd016e0b0840476f5edd490c75a64c0a1ffc8a7dca"
  license "LGPL-3.0-only"
  head "https://github.com/radareorg/radare2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "431bff63c257ee182cf95687c9e275f1f968d987786ff1d5444fa33f4d5e1e4e"
    sha256 arm64_sequoia: "009958bcbeddf6e01654399cef2d892d82e375383496b1792b171a86908549c6"
    sha256 arm64_sonoma:  "7495d4b4ce8ccb5430195a7af6e123c4d6d3ceeb9c48061fd1b039b408470817"
    sha256 sonoma:        "c7d0415cd0e6713544cf3e0734b119ef491bcfb0b6014358e9aaa1297b5242e0"
    sha256 arm64_linux:   "3c2309752d275f1fd9567346df8518043907723fef14f9ae1cc66060d6614263"
    sha256 x86_64_linux:  "d890838a320f89e6ec669d9c689a837df4039d37b448190b07a6105b20e2a89f"
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
