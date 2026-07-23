class Supermodel < Formula
  desc "Sega Model 3 arcade emulator"
  homepage "https://github.com/trzy/Supermodel"
  url "https://github.com/trzy/Supermodel/archive/refs/tags/v0.3a-20260712-git-fef2b38.tar.gz"
  version "0.3a-20260712-git-fef2b38"
  sha256 "66252473ebaab35f75ba876defc93fe3d4c0ef4694a2e5c7b1ae81f45a5c3b72"
  license "GPL-3.0-or-later"
  head "https://github.com/trzy/Supermodel.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a5e421c80ffe138c793556b9dad8ca976fd1d81486dfc959286a10066db9cea8"
    sha256 cellar: :any, arm64_sequoia: "e00faf7ccd57bd5fe182c2aae74356a9750620c2651322a44e3eb68a7f5cea0d"
    sha256 cellar: :any, arm64_sonoma:  "e23579edefa3dd6d1a5e8f88561203f15b399205001cb9c1cda4ef77e70a46dd"
    sha256 cellar: :any, sonoma:        "7a3c0f6824aae404196523aa60c07179c291614b25e03989b7ff4ca1c7f47351"
    sha256 cellar: :any, arm64_linux:   "18fe8b43894670d490dda20c96ac0ff53e8ab14fbd960a1e449b11f8591d5948"
    sha256 cellar: :any, x86_64_linux:  "c0306fec6b1a9ada44bbfea7afbdb4120d59e04ab236c93e49017f89d91883ae"
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
