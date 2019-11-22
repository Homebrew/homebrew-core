class Yash < Formula
  desc "Yet another shell: a POSIX-compliant command-line shell"
  homepage "https://yash.osdn.jp/"
  # Canonical: https://osdn.net/dl/yash/yash-*
  url "https://dotsrc.dl.osdn.net/osdn/yash/71638/yash-2.49.tar.xz"
  sha256 "66eaf11d6c749165a7503801691759ae151e4eae00785875e121db2e9c219c72"

  bottle do
    sha256 "bdea912700abd0af3cfadf0b53498389bf8712fbcc05a4e4dff1facc49a05238" => :catalina
    sha256 "006b68f9a1cfa870cdc2e77832ca43612cab41007217830b6448a2d60851f4ca" => :mojave
    sha256 "a6bea4d4ebf343937daa87f97189d868368b8626d14d75fd1d07adc470e07850" => :high_sierra
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
