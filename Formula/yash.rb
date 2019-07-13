class Yash < Formula
  desc "Yet another shell: a POSIX-compliant command-line shell"
  homepage "https://yash.osdn.jp/"
  # Canonical: https://osdn.net/dl/yash/yash-*
  url "https://dotsrc.dl.osdn.net/osdn/yash/70439/yash-2.48.tar.xz"
  sha256 "f46294d77c5a646405db20a6dc3d16bc1ed109b061b2a508081ce483153c1e8d"

  bottle do
    sha256 "21b9fe172294391e52d14a6def4196d7348555a2567077090ee858175dd953ee" => :mojave
    sha256 "01618cb1cf1c5c93500769c5b456d59094dc1502aaa75dd38cd318b68eecef9e" => :high_sierra
    sha256 "0617778d65554225c7fff2baa26b6cffa872669cf490744bc63f8a990b655551" => :sierra
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
