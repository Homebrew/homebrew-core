class Supermodel < Formula
  desc "Sega Model 3 arcade emulator"
  homepage "https://github.com/trzy/Supermodel"
  url "https://github.com/trzy/Supermodel/archive/refs/tags/v0.4-20261107-git-d0cdfa1.tar.gz"
  version "0.4-20261107-git-d0cdfa1"
  sha256 "f70bdabc97db4cded835edcebf1047d5621dffc6ddf1b27de79293b89b96d7b5"
  license "GPL-3.0-or-later"
  head "https://github.com/trzy/Supermodel.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "87641b969e35395bacc097dfcec1396c84685417ca2d34e89f194aaa6dd77a67"
    sha256 cellar: :any, arm64_tahoe:       "e37be22141ecaf7d6d8f0ed61435b5821f0140e6b21a2a9117fb603dc1d3b64f"
    sha256 cellar: :any, arm64_sequoia:     "6a3b258b3e0046e7170d78fc679d4b6f994be3550dff4d8873203afb2942f3ce"
    sha256 cellar: :any, arm64_linux:       "85d613f24fce61c3a47666133b62fb617cd4361f76b2921c5f7abf34d449db0c"
    sha256 cellar: :any, x86_64_linux:      "f58cb4043a2fe0ff93d7a9f7ce4dee9c44cca2844e458b4764071fe76dbe616a"
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
