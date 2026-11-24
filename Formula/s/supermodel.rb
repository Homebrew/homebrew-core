class Supermodel < Formula
  desc "Sega Model 3 arcade emulator"
  homepage "https://github.com/trzy/Supermodel"
  url "https://github.com/trzy/Supermodel/archive/refs/tags/v0.4-20261123-git-cd9c9d3.tar.gz"
  version "0.4-20261123-git-cd9c9d3"
  sha256 "dcb2c7b9a79e0805ecad9986b832b3112cf63aa95531ae7b731e09bc12d6894a"
  license "GPL-3.0-or-later"
  head "https://github.com/trzy/Supermodel.git", branch: "master"

  bottle do
    manifest_sha256 "32420f2de4eea1ce1158fc66cafe1aa3c09c5562d503be00171a7ba34da8ecbe"
    sha256 cellar: :any, arm64_golden_gate: "b18c2a9bc6d83c867d6b28cf54cff521a16f2ceb3e9bc9dade001698051a6475"
    sha256 cellar: :any, arm64_tahoe:       "7cfb43876b4894fed2b12d1a687215371c23c7394dc06d8fd5fabeeb91cba064"
    sha256 cellar: :any, arm64_sequoia:     "3924b8791c6150602802404c2c9f272613d2f5fb322d80ca2f898c983155814e"
    sha256 cellar: :any, arm64_linux:       "f822e38dbf31c336b41a89c3295f0f056e6ee6d1ebdac39d774ea6373360efcd"
    sha256 cellar: :any, x86_64_linux:      "7ed121c01eed97e05092aa18cc31e989094acacf4985b254ddb8a17dec0f3a35"
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
