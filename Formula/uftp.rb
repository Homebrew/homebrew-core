class Uftp < Formula
  desc "Secure, reliable, efficient multicast file transfer program"
  homepage "https://uftp-multicast.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/uftp-multicast/source-tar/uftp-5.0.tar.gz"
  sha256 "562f71ea5a24b615eb491f5744bad01e9c2e58244c1d6252d5ae98d320d308e0"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/uftp[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_big_sur: "b38ccf77d80d8b662c86abd4c11b3c94e6a1a166b011392f16261289ebb1d923"
    sha256 cellar: :any,                 big_sur:       "8bb1c997a162785aae612d640fb4e9a69c22af980b38d82484b899041c024f1b"
    sha256 cellar: :any,                 catalina:      "9a5f0d2a7fd5887a164733d78a5d57ded16f398284d58b258ca7221f3e5287e6"
    sha256 cellar: :any,                 mojave:        "7193614091b37c59942a9d0cdf0cca676083b83062cc3db48c15a097734cc1d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec38c9a94075abab2dc63914921a3b045de4ab5a64639d0db99a2e84b58b9960"
  end

  depends_on "openssl@1.1"

  def install
    system "make", "OPENSSL=#{Formula["openssl@1.1"].opt_prefix}", "DESTDIR=#{prefix}", "install"
    # the makefile installs into DESTDIR/usr/..., move everything up one and remove usr
    # the project maintainer was contacted via sourceforge on 12-Feb, he responded WONTFIX on 13-Feb
    prefix.install Dir["#{prefix}/usr/*"]
    (prefix/"usr").unlink
  end

  service do
    run [opt_bin/"uftpd", "-d"]
    keep_alive true
    working_dir var
  end

  test do
    system "#{bin}/uftp_keymgt"
  end
end
