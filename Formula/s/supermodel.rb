class Supermodel < Formula
  desc "Sega Model 3 arcade emulator"
  homepage "https://github.com/trzy/Supermodel"
  url "https://github.com/trzy/Supermodel/archive/refs/tags/v0.4-20261121-git-d430b94.tar.gz"
  version "0.4-20261121-git-d430b94"
  sha256 "381bd403be6355c4fe00797e49260371eae3af212d6375fd513a7af7a5957dac"
  license "GPL-3.0-or-later"
  head "https://github.com/trzy/Supermodel.git", branch: "master"

  bottle do
    manifest_sha256 "4f0ad093bd39aa083086b3c5f3c8d99318e949a012d328de714b720d010f6b2f"
    sha256 cellar: :any, arm64_golden_gate: "4ad73fbd5c439dcbe879b83f633af8deb919c9db967051e6dc334f91215fd910"
    sha256 cellar: :any, arm64_tahoe:       "12ef3a4cc85f7b95654bae3338fbc8024f8bd90f6d67cd0a6abc157c617d421a"
    sha256 cellar: :any, arm64_sequoia:     "3ade8e663346c6f08d55a0e6013541257145b4b540fc7d69651ffb694f7269a9"
    sha256 cellar: :any, arm64_linux:       "1707fd5aafcd8a485c6d67dbc5b90257f6465b3b641415210e5d0421b7c283e2"
    sha256 cellar: :any, x86_64_linux:      "d1ab52f28bd44d094a37a722141f7f5150cc3412a3ebd55692b6e16ffa5e6d0f"
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
