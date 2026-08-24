class Xterm < Formula
  desc "Terminal emulator for the X Window System"
  homepage "https://invisible-island.net/xterm/"
  url "https://invisible-mirror.net/archives/xterm/xterm-411.tgz"
  mirror "https://deb.debian.org/debian/pool/main/x/xterm/xterm_411.orig.tar.gz"
  sha256 "969be283670deadd66934865c4de6c5ab045e3a3facc2b228decf91a20d8c36c"
  license all_of: ["X11", "HPND"]

  livecheck do
    url "https://invisible-mirror.net/archives/xterm/"
    regex(/href=.*?xterm[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "e5e7f1d9766d3d68998f905f32ea072ecc3e421d3f751e8b5154e7f7c86d6f31"
    sha256 arm64_sequoia: "5dd565028ba9c7cd23933a19ddf73cd642062fb1bef1dfedb5b78c711682c756"
    sha256 arm64_sonoma:  "f8cff5dcf5084a404cd1cc5af487197142b8d93fb3b09a96fbdbc9a2a5eba6dc"
    sha256 sonoma:        "f741af446258362271c29ee027386abf89efe0b2efa4078a18b973c1bca6e9e7"
    sha256 arm64_linux:   "fa56ca77e6349081a6ff8e5277fd62bdcc32c7a86bb39a8d01e3597bb37c8e9a"
    sha256 x86_64_linux:  "9a7801b7a49db67ad3ccc12bf5712f366ac27b0376788c00a2277f817d3c908f"
  end

  depends_on "pkgconf" => :build
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "libice"
  depends_on "libx11"
  depends_on "libxaw"
  depends_on "libxext"
  depends_on "libxft"
  depends_on "libxinerama"
  depends_on "libxmu"
  depends_on "libxpm"
  depends_on "libxt"

  uses_from_macos "ncurses"

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    %w[koi8rxterm resize uxterm xterm].each do |exe|
      assert_path_exists bin/exe
      assert_predicate bin/exe, :executable?
    end
  end
end
