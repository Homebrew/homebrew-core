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
    sha256 "e9ce00f183e818cc273cae2748dc2c5021565083870351b5ac391548baa49580" => :big_sur
    sha256 "7e92afc1391f9d80bcab553e29705fd0cb11c88ae10448a7d57d408284c8490f" => :catalina
    sha256 "1ce52a85f6ed173af4e6e296a1051b08536a31d7e7c8704d0324bb4d2c751fad" => :mojave
    sha256 "026106ab6ee3296619ad4cd762756d4676713feb7060172cabc39e92d8f222a0" => :high_sierra
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
