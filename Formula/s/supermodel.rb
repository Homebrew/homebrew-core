class Supermodel < Formula
  desc "Sega Model 3 arcade emulator"
  homepage "https://github.com/trzy/Supermodel"
  url "https://github.com/trzy/Supermodel/archive/refs/tags/v0.3a-20260726-git-8488f0d.tar.gz"
  version "0.3a-20260726-git-8488f0d"
  sha256 "30f4d1da13ce31da293694f98a52bd5622d4653cf40599cbf9a914a57b69d34a"
  license "GPL-3.0-or-later"
  head "https://github.com/trzy/Supermodel.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f66c19280d9b528cb006e5e09ce7ba22dcc90fdf73954110898d60c3f112f797"
    sha256 cellar: :any, arm64_sequoia: "d682e5d87f9f0cc4829649b814e26ac3c1d97b8ce779d0dffa4e10fb399a6a2a"
    sha256 cellar: :any, arm64_sonoma:  "eeb713a4a530d8e587e2b353c8d403f34f27fabb06f36a1b7db4d35de3942486"
    sha256 cellar: :any, sonoma:        "6e610b84726981f8f7fd3d85de1f2224980d501e3123b7818d769e041fbe6035"
    sha256 cellar: :any, arm64_linux:   "94dc19171d4822ece60a08d904bf0e3a7e266cac66a468c57e415fbb22118f31"
    sha256 cellar: :any, x86_64_linux:  "3197f4b02a7b2480c66b7d9ba7b30687fa048bca068cdba6fdded5928571a78e"
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
