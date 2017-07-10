class Yash < Formula
  desc "Yet another shell: a POSIX-compliant command-line shell"
  homepage "https://yash.osdn.jp/"
  url "http://dl.osdn.jp/yash/67984/yash-2.45.tar.xz"
  sha256 "5b127d71e0e1edd462b224322c01332819a38eaa442baad807283e139ee56e11"

  bottle do
    sha256 "da1943d53ced363a3670017129947a4ba996ec82604112788ad7f02830612663" => :sierra
    sha256 "6c212b53de2e7dfc29a5c84be0242553f96c3873f5926b5168ce9cf374479c91" => :el_capitan
    sha256 "547509067bd7e0d2c0cc6e6156b3d2abbd9fb1d67cc106538d2443fbcbd872a5" => :yosemite
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
