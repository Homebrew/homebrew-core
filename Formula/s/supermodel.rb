class Supermodel < Formula
  desc "Sega Model 3 arcade emulator"
  homepage "https://github.com/trzy/Supermodel"
  url "https://github.com/trzy/Supermodel/archive/refs/tags/v0.4-20261121-git-8247e86.tar.gz"
  version "0.4-20261121-git-8247e86"
  sha256 "9e1ea77a8f720406e07dcd46637e0e0d3f8042db173bcd7cd18a9593cf6e5634"
  license "GPL-3.0-or-later"
  head "https://github.com/trzy/Supermodel.git", branch: "master"

  bottle do
    manifest_sha256 "31ccd92a40f2460345121aa604871bc942d339029914c23e576142bb6ad15ffa"
    sha256 cellar: :any, arm64_golden_gate: "9dbe8ba10991ca6cc577df01e833af1728a3d88a2bcc26a57dab79af9577ce7b"
    sha256 cellar: :any, arm64_tahoe:       "f18e68ccd4fcef6c2ec764c3750746de695e37463e6926935afc2241338ca89a"
    sha256 cellar: :any, arm64_sequoia:     "06f5a722f0d8d3795605152043d70b54ce01867338fdefe6c1496111be71f935"
    sha256 cellar: :any, arm64_linux:       "fbe587ecdabd1574e866d544b0510db75bd83f024b80bf33b340828aa2173738"
    sha256 cellar: :any, x86_64_linux:      "b3893ee21062143490207e80099ca376a440d3bb80cc60a32ce8e711ac702435"
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
