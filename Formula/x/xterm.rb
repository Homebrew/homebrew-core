class Xterm < Formula
  desc "Terminal emulator for the X Window System"
  homepage "https://invisible-island.net/xterm/"
  url "https://invisible-mirror.net/archives/xterm/xterm-401.tgz"
  mirror "https://deb.debian.org/debian/pool/main/x/xterm/xterm_401.orig.tar.gz"
  sha256 "3da2b5e64cb49b03aa13057d85e62e1f2e64f7c744719c00d338d11cd3e6ca1a"
  license "X11"

  livecheck do
    url "https://invisible-mirror.net/archives/xterm/"
    regex(/href=.*?xterm[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "6675a252e6ad9b43cadfb53f3c4539608bd2903ebbcd768af55ad3fe98a98a8f"
    sha256 arm64_sonoma:  "15482d8ad616d132888da95bc84fbee365efd96444125ff553d75ee580f1bfae"
    sha256 arm64_ventura: "e5b068c104f090921577c4a17ec4785bcff35d7b3c2e3d528ee7fd45b4ca531a"
    sha256 sonoma:        "06c6a68219adbb2a06bb309c7cd4fd1bc20886fb7379e181e0238103b7802fb3"
    sha256 ventura:       "9d92b175307005816fdbf918f827ce534168105bd7f55db89a41047e4cf3e374"
    sha256 arm64_linux:   "a23460d903c650f5e72adab300f818246391bfebcba12fa5aff9aa06bcbb730c"
    sha256 x86_64_linux:  "b952f72582ea5a7b85016a697d08bbaedb113cbcb693acfdfa9c4b3f80ea04d1"
  end

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
