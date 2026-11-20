class Supermodel < Formula
  desc "Sega Model 3 arcade emulator"
  homepage "https://github.com/trzy/Supermodel"
  url "https://github.com/trzy/Supermodel/archive/refs/tags/v0.4-20261119-git-596f154.tar.gz"
  version "0.4-20261119-git-596f154"
  sha256 "057253bc2e449c5d7d52db8b7a78dd308b3c8473d06a2a38e05cd50a81b31b64"
  license "GPL-3.0-or-later"
  head "https://github.com/trzy/Supermodel.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d62852f9a84ffa86461ae5fa8c9d43854db655784c706ff282a2748e9747ce2c"
    sha256 cellar: :any, arm64_tahoe:       "8705ede606acc87ca62dd3d0ac14678f3ccd8d1f30746836e1cdcccb0d73f6b6"
    sha256 cellar: :any, arm64_sequoia:     "fc83bcfaec311243b3a19b5a68279d87166d5857611ec55f3ac36197aefcf801"
    sha256 cellar: :any, arm64_linux:       "db8f88a90702ade97a7c44d18a09fa3ba4000fd6ec2c0e9cd12fdb75a8b1eb77"
    sha256 cellar: :any, x86_64_linux:      "938ccf26776a80fef5f91ed0d0d28c7219edeff5374bf751162ffaa20245c789"
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
