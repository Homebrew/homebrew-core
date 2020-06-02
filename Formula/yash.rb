class Yash < Formula
  desc "Yet another shell: a POSIX-compliant command-line shell"
  homepage "https://yash.osdn.jp/"
  # Canonical: https://osdn.net/dl/yash/yash-*
  url "https://dotsrc.dl.osdn.net/osdn/yash/73097/yash-2.50.tar.xz"
  sha256 "b6e0e2e607ab449947178da227fa739db4b13c8af9dfe8116b834964b980e24b"

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
