class Supermodel < Formula
  desc "Sega Model 3 arcade emulator"
  homepage "https://github.com/trzy/Supermodel"
  url "https://github.com/trzy/Supermodel/archive/refs/tags/v0.4-20261107-git-4926081.tar.gz"
  version "0.4-20261107-git-4926081"
  sha256 "0d2a475e7d465c1cae2e9cfa4f279aef21be221b6b8dfac5a4a37c793af5b60c"
  license "GPL-3.0-or-later"
  head "https://github.com/trzy/Supermodel.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "887c8c22b8d012469bd9dc7e6e8e7dd9cda9af4aeff21bff0a32c4f476dfb771"
    sha256 cellar: :any, arm64_tahoe:       "4fd182e26c75e42a989e43dd9453b3cc9e631dbfe8b84b0abb4f559c9d4cd91f"
    sha256 cellar: :any, arm64_sequoia:     "b441d706bae518260e999d7e0f62f167d7507cc530459ec9067843f462f07b23"
    sha256 cellar: :any, arm64_linux:       "aa7a69d5cf7592149bd60682df3d30cbf4661565b61d7f4ad3a08869e1d105cd"
    sha256 cellar: :any, x86_64_linux:      "f703ba5525439053c11671822391c5f03489a4edfdf32010bb6c304e5d622171"
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
