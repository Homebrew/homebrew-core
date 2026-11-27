class Supermodel < Formula
  desc "Sega Model 3 arcade emulator"
  homepage "https://github.com/trzy/Supermodel"
  url "https://github.com/trzy/Supermodel/archive/refs/tags/v0.4-20261127-git-85dd58e.tar.gz"
  version "0.4-20261127-git-85dd58e"
  sha256 "46bff6c6997513a7c3a019402476f02f15d9faff1c4c5fcc83f8db3c056696c9"
  license "GPL-3.0-or-later"
  head "https://github.com/trzy/Supermodel.git", branch: "master"

  bottle do
    manifest_sha256 "a089429f006e76bd06bda23f02af9a59af34a3950d61f58d3b0fc3ed1f3c4f29"
    sha256 cellar: :any, arm64_golden_gate: "dd4a3a9ce8d9ed7b06e558ebc215aed738028ad318d4cbfce57b3c8c634e11f8"
    sha256 cellar: :any, arm64_tahoe:       "a4d7984103ef1c22def36f9d1cb301496ddc45c07b279bade1e380c95c1f405a"
    sha256 cellar: :any, arm64_sequoia:     "bbf901b5e6ee04cac4f0c7990d34b52ab9c4f1287c8c0dcf80bca6a6748dbea2"
    sha256 cellar: :any, arm64_linux:       "c8dbb172193f9c8b4dde0a17f0fe781bdf278d3e55ceeff97e52a51813fdcc55"
    sha256 cellar: :any, x86_64_linux:      "dca26a26b501a4e2ca8754e58556b0791a31704849525014e4bdb6d97afb8414"
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
