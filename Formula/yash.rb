class Yash < Formula
  desc "Yet another shell: a POSIX-compliant command-line shell"
  homepage "https://yash.osdn.jp/"
  # Canonical: https://osdn.net/dl/yash/yash-2.46.tar.xz
  url "https://dotsrc.dl.osdn.net/osdn/yash/68578/yash-2.46.tar.xz"
  sha256 "93431d897ce2b176c9f97b879c70a426ebc125b073d5894c00cd746f3a8455cb"

  bottle do
    sha256 "efa74af51e2b6eb275952a2ae604e722630b730073417b4277b58631c07ec233" => :high_sierra
    sha256 "ca4885e4c6331f0ca14b85420ddbf1106a5f554b27425078d9922b6fc87daf0a" => :sierra
    sha256 "418f3180d168044f1f462e3d5e0d26d49dd32ad4b4782ad48db4c91c0a416254" => :el_capitan
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
