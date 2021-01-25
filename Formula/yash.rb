class Yash < Formula
  desc "Yet another shell: a POSIX-compliant command-line shell"
  homepage "https://yash.osdn.jp/"
  # Canonical: https://osdn.net/dl/yash/yash-*
  url "https://dotsrc.dl.osdn.net/osdn/yash/74064/yash-2.51.tar.xz"
  sha256 "6f15e68eeb63fd42e91c3ce75eccf325f2c938fa1dc248e7213af37c043aeaf8"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://osdn.jp/projects/yash/releases/rss"
    regex(%r{(\d+(?:\.\d+)+)</title>}i)
  end

  bottle do
    sha256 "0148513daad07ea6867715f97d04d8f2eb66b4efe937d51bc7616d99d1aaef58" => :big_sur
    sha256 "b9f491ea8170c99d1d2218644043acbceb12c118c64c5c2f415230ffff3d2eb6" => :arm64_big_sur
    sha256 "f9d79d098c75b321288c45626bec895e2ce35f8c68fcbd1d6405a0b6614226fb" => :catalina
    sha256 "0eec194f969eb03add9615ed1f4569749ff423007552fdf40b12b7df82c72024" => :mojave
  end

  depends_on "gettext"

  def install
    system "sh", "./configure",
            "--prefix=#{prefix}",
            "--enable-array",
            "--enable-dirstack",
            "--enable-help",
            "--enable-history",
            "--enable-lineedit",
            "--enable-nls",
            "--enable-printf",
            "--enable-socket",
            "--enable-test",
            "--enable-ulimit"
    system "make", "install"
  end

  test do
    system "#{bin}/yash", "-c", "echo hello world"
  end
end
