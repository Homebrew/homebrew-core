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
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "e62bde780e31b0969be51009065d1538dcd0005faa72b5763d6377f73c9806c3"
    sha256 cellar: :any,                 arm64_monterey: "419327bcf6a91fd632ae4760b3a2d6106c38faa9c88b531af321a4ada30c8c10"
    sha256 cellar: :any,                 arm64_big_sur:  "1637d53cf74b59de04fb159100a40a68e0f2eb697d5d762cb4fed3910c64b724"
    sha256 cellar: :any,                 ventura:        "fae25917793047496dc4cffcc9c56a3d3adfb6095d9bf9e43052c7aa83b3b27e"
    sha256 cellar: :any,                 monterey:       "46c192edc8c39d3d42a255d1bfce9e6a4caecbdb2a8a973b7796caed331a8e64"
    sha256 cellar: :any,                 big_sur:        "19cbee73d08382f5d52e5fa3c4dc5f2b227653bd17427d9dfe7ebcc531fc0eb5"
    sha256 cellar: :any,                 catalina:       "f6a4cbcb1b447a5477eb21984fdf0d05394a9a9b16e07c36e3f04dbbfc6065e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b7469a4e9370f1f60272d22187d80419d90f52302b7d87923a1f54e6694ced3"
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
