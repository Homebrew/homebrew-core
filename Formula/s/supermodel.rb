class Supermodel < Formula
  desc "Sega Model 3 arcade emulator"
  homepage "https://github.com/trzy/Supermodel"
  url "https://github.com/trzy/Supermodel/archive/refs/tags/v0.3a-20261020-git-98fcbff.tar.gz"
  version "0.3a-20261020-git-98fcbff"
  sha256 "e8dd48fa2733ef927c3a3ade5f651c6a454418988fc02226e4f520cb4894be76"
  license "GPL-3.0-or-later"
  head "https://github.com/trzy/Supermodel.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f77c744a36bb4a7b8672d1c0ad0d11d6be602b70cc0e465711521944ebe72a68"
    sha256 cellar: :any, arm64_tahoe:       "a78946e8471b2e5c9f5c65f352902b9e158762ece6ae485e1b797fd4de0147f4"
    sha256 cellar: :any, arm64_sequoia:     "507fbdd2a49666a28765cba13ac67542d1276f0342d065df0da29ebe97734c0e"
    sha256 cellar: :any, arm64_linux:       "7a68e9c784bbe7eced7b95400952f5c767de881b0941d25ed395bba0b3bbe946"
    sha256 cellar: :any, x86_64_linux:      "2deaf83ad7b8b198ebdfbdff3ce6438fe8a96e9b439646c8e15dd262dc903b82"
  end

  depends_on "sdl2-compat"
  depends_on "sdl2_net"

  on_linux do
    depends_on "mesa"
    depends_on "mesa-glu"
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    # Not using Makefile.OSX as it uses prebuilt frameworks
    system "make", "-f", "Makefiles/Makefile.UNIX", "BIN_DIR=#{bin}"
  end

  test do
    system bin/"supermodel", "-print-games"
  end
end
