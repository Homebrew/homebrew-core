class Yash < Formula
  desc "Yet another shell: a POSIX-compliant command-line shell"
  homepage "https://yash.osdn.jp/"
  # Canonical: https://osdn.net/dl/yash/yash-*
  url "https://dotsrc.dl.osdn.net/osdn/yash/69353/yash-2.47.tar.xz"
  sha256 "931f2e7451d8b1eca2a98caeef7eda0527d96376f9f2c9bec90bc5938e39992e"

  bottle do
    sha256 "a80b7e4adc5bb6bbfdb85ad01c761889026617455eb686eca20849c26bfbc159" => :mojave
    sha256 "8ceb88372ff9dbf2461994e646b7743c3fb927115fbd540fdd8a163a9c929916" => :high_sierra
    sha256 "3b13c76147e4835eeff1b1794eb534deedaf6e787d3871a233f8dd34b9003fe9" => :sierra
    sha256 "9fc6669b72248884e4274f695b9188745e5ae8fac359862373efa9a6f98b7469" => :el_capitan
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
