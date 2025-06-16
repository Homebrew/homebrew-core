class Xterm < Formula
  desc "Terminal emulator for the X Window System"
  homepage "https://invisible-island.net/xterm/"
  url "https://invisible-mirror.net/archives/xterm/xterm-400.tgz"
  mirror "https://deb.debian.org/debian/pool/main/x/xterm/xterm_400.orig.tar.gz"
  sha256 "eed84ecc05efa63d589c5a2a3f5a947e14b798d03b5342cc6883710f648f1a06"
  license "X11"

  livecheck do
    url "https://invisible-mirror.net/archives/xterm/"
    regex(/href=.*?xterm[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "46d7eb07095fb1e696efb4e8049b942d72549cdf6c56ca0ab6b269a6ad6ea373"
    sha256 arm64_sonoma:  "7456c958a3ffd316137303d0a4733387a35975f883bf2e97f6490cdbf62ad942"
    sha256 arm64_ventura: "9bb6fd67dc6ba099f6574f04ce22f99a22b5f6068c484fbd1777338040864b1d"
    sha256 sonoma:        "39d432484bb4ddcb693d47f0b410b15e8ba2e163eb89a7ebd5eef2ca33153bfb"
    sha256 ventura:       "c7f2e5e7910d5e76801ad037d9cb19d43d567e221d3835a0488d501541caea52"
    sha256 arm64_linux:   "e0ee9ce64a32673ec29b69d750aee1b80d4e1592d950f6103c0f18d4e3bfa246"
    sha256 x86_64_linux:  "80421c55a4b3a6dd54513cbe06813242b813171046f44b9f07abc9d01e06469a"
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
