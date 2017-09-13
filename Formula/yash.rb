class Yash < Formula
  desc "Yet another shell: a POSIX-compliant command-line shell"
  homepage "https://yash.osdn.jp/"
  url "http://dl.osdn.jp/yash/67984/yash-2.45.tar.xz"
  sha256 "5b127d71e0e1edd462b224322c01332819a38eaa442baad807283e139ee56e11"

  bottle do
    sha256 "e480eb53b583ca70cd1976f62898d59c23551bb82c3bf830eb8c5efef64ed2ad" => :sierra
    sha256 "811d8ba86be74330f2611c17744f147c538551672d437da16c9dc5bf3f93a4dd" => :el_capitan
    sha256 "998a98901ab1b4917a5b4c03032d2e2a014d87a648dfcc8324e5f6e36beb7325" => :yosemite
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
