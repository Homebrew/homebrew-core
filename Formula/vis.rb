class Vis < Formula
  desc "Vim-like text editor"
  homepage "https://github.com/martanne/vis"
  url "https://github.com/martanne/vis/archive/v0.2.tar.gz"
  sha256 "3e5b81d760849c56ee378421e9ba0f653c641bf78e7594f71d85357be99a752d"

  head "https://github.com/martanne/vis.git"

  bottle do
    cellar :any
    sha256 "ddd993ff3896295ed2e224c10c4a21de7fdc19f50d62fdaca49fa0f8bccb1621" => :el_capitan
    sha256 "2fbde4500fbf8a25c8e07ad4a5a62231778fe0d2f01a01c855889940629730cd" => :yosemite
    sha256 "f11564785c0a4d4884ca69ad425af43b1f9ce629dcf92ce2e1e1f438998707d6" => :mavericks
  end

  depends_on "lua" => :recommended
  depends_on "libtermkey"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    shell_output("#{bin}/vis -v 2>&1", 1)
  end
end
