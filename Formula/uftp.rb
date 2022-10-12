class Uftp < Formula
  desc "Secure, reliable, efficient multicast file transfer program"
  homepage "https://uftp-multicast.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/uftp-multicast/source-tar/uftp-5.0.1.tar.gz"
  sha256 "f0435fbc8e9ffa125e05600cb6c7fc933d7d587f5bae41b257267be4f2ce0e61"
  license "GPL-3.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :stable
    regex(%r{url=.*?/uftp[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d8d9b1b7a1c7e9a359242de153b087f05dee5a65d0261b042040464edd9613af"
    sha256 cellar: :any,                 arm64_big_sur:  "ef47b9d11a228c6daa4e8a8311ed4e2e0f983aa1036efcc7029895d0b56631b7"
    sha256 cellar: :any,                 monterey:       "ca0f38ccddec9d9e655874dfd129609fa72fb0d428769b34e97f8b21ae11cab1"
    sha256 cellar: :any,                 big_sur:        "d15a9b0f78488e86e802bc67e949b0ec9ceaf38e1096be34e007440e0c519a4e"
    sha256 cellar: :any,                 catalina:       "8cdfc5565a6010c1149e72c910751a65e8792e4ef4c02a76f170da4a46b3e376"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab28f1ccdf3f8f1aff8c2123122fb41f32bd6e5f235945e37322241696f32191"
  end

  depends_on "openssl@3"

  def install
    system "make", "OPENSSL=#{Formula["openssl@3"].opt_prefix}", "DESTDIR=#{prefix}", "install"
    # the makefile installs into DESTDIR/usr/..., move everything up one and remove usr
    # the project maintainer was contacted via sourceforge on 12-Feb, he responded WONTFIX on 13-Feb
    prefix.install (prefix/"usr").children
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
