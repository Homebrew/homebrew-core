class Xterm < Formula
  desc "Terminal emulator for the X Window System"
  homepage "https://invisible-island.net/xterm/"
  url "https://invisible-mirror.net/archives/xterm/xterm-412.tgz"
  mirror "https://deb.debian.org/debian/pool/main/x/xterm/xterm_412.orig.tar.gz"
  sha256 "b48bc780c1cbc14f6d89269f7e593712af6095876960d650be28b55e5dad65a6"
  license all_of: ["X11", "HPND"]
  compatibility_version 1

  livecheck do
    url "https://invisible-mirror.net/archives/xterm/"
    regex(/href=.*?xterm[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "e6997c4eb2197351ba1e7035d015dc9c15136542e9af3db4006b2335b9eb0d42"
    sha256 arm64_tahoe:       "1b6eb55d2c01a7e8b1cc26b4da045888e7367550c3b68870b7e8663691103236"
    sha256 arm64_sequoia:     "5dc262045506113bae0820899f8fb2c6b21c14f79ed5df683025cd2ef5c3481f"
    sha256 arm64_linux:       "07c3921621823406c47525dbdfdcb547bd03528484f216e3c6f63be1a945c318"
    sha256 x86_64_linux:      "cedb2beebb5961616a68cc5cd4175a03ac4965e3fc658e267086b5eb0988a452"
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

  deny_network_access!

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
