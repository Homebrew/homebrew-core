class Supermodel < Formula
  desc "Sega Model 3 arcade emulator"
  homepage "https://github.com/trzy/Supermodel"
  url "https://github.com/trzy/Supermodel/archive/refs/tags/v0.4-20261122-git-550bd30.tar.gz"
  version "0.4-20261122-git-550bd30"
  sha256 "8423c4a65fe472559116c1b0fca2b863778014b823d14f4ac9bfd05be1ebd43b"
  license "GPL-3.0-or-later"
  head "https://github.com/trzy/Supermodel.git", branch: "master"

  bottle do
    manifest_sha256 "420e69187c0af7625b2b8c300b944296783b9e5223599a80ad0ab7a4633d0019"
    sha256 cellar: :any, arm64_golden_gate: "d71da4c0632d6155ad808ac3abd2df91f56d028c72106569db5ecc1636ca4c28"
    sha256 cellar: :any, arm64_tahoe:       "f4fa396019e982b619650ac0b757f951a9dd505c3f90f06ab183e59dcc6c3ac7"
    sha256 cellar: :any, arm64_sequoia:     "e8bdcdc6d45ab730b53abd797e1e7469914e1af38063ce978a6279772d10a2f5"
    sha256 cellar: :any, arm64_linux:       "fa216ef9cb0173ff6310c81cbd8d7781de1cccb92c2931e194e25db3d7149f10"
    sha256 cellar: :any, x86_64_linux:      "6c54a917676362fee366763fdb3f0a8a3d0b67cfd8b76546666cb7a6865e1637"
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
