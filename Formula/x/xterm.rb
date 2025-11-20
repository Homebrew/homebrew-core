class Xterm < Formula
  desc "Terminal emulator for the X Window System"
  homepage "https://invisible-island.net/xterm/"
  url "https://invisible-mirror.net/archives/xterm/xterm-403.tgz"
  mirror "https://deb.debian.org/debian/pool/main/x/xterm/xterm_403.orig.tar.gz"
  sha256 "1331b0df5919cb243ffe326dc6ff10a291e683a262f70cdf964a664be733ad83"
  license "X11"

  livecheck do
    url "https://invisible-mirror.net/archives/xterm/"
    regex(/href=.*?xterm[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "c778ddfc075942b963255d2bfbb9a30e373447f309a02ec1d8f3a9d4cd8f82c2"
    sha256 arm64_sequoia: "07b85bd73ba37391d6769adcbb76945e3dfefac72a0598c104e87aaa788d1635"
    sha256 arm64_sonoma:  "1a4b645c4f49f0b7425a254553a7fb80c8a159bb5e89a0b600808975c59931e7"
    sha256 sonoma:        "7866feacb67ad0b6eedded4175b7253d413de008f98b4a57aa8135ffa356fdc3"
    sha256 arm64_linux:   "139a96b853e7ca0f4923f0858bcecae0e4a2f28beb4cb842e6791d26c0d30d79"
    sha256 x86_64_linux:  "0cdd5352028604b98337d54147a3e322a4c5ba58ba8fa3fbd342f48a0320b45a"
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
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    %w[koi8rxterm resize uxterm xterm].each do |exe|
      assert_path_exists bin/exe
      assert_predicate bin/exe, :executable?
    end
  end
end
