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
    rebuild 2
    sha256 cellar: :any,                 arm64_monterey: "f8c933067b1bf178dd93aaa2a900097481d5be013230d740062eaa46cf975af8"
    sha256 cellar: :any,                 arm64_big_sur:  "114882e78afa5b2cce141e3e19b01022a4eeb3c4e1cbae7934d36ce99df7f1ff"
    sha256 cellar: :any,                 monterey:       "a5e3cb283187e9cca940beaff105e2cacbc9a9b210c8673fe703ae9543658a98"
    sha256 cellar: :any,                 big_sur:        "6ea6e3b9e53d1040ebc6f1a25b58247ebe5972e1479002100e6b5d167b2c5e54"
    sha256 cellar: :any,                 catalina:       "ef74aa1112e9f5b325bb1403de71fa604532806dadfd97368e778be187ddee13"
    sha256 cellar: :any,                 mojave:         "17253bb38570db26a53eab4cc75d809b32bff3db8ecdf48d9dfb03b453866ac0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d550e280c49503b83b5bc2f30092dedc67e8b0ff0937dcbc487e475c0f1ee02"
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
