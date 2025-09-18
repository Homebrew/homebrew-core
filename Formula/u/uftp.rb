class Uftp < Formula
  desc "Secure, reliable, efficient multicast file transfer program"
  homepage "https://uftp-multicast.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/uftp-multicast/source-tar/uftp-5.0.3.tar.gz"
  sha256 "cb8668c19b1f10bc63a16ffa893e205dc3ec86361037d477d8003260ebc40080"
  license "GPL-3.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :stable
    regex(%r{url=.*?/uftp[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "fb631c49f47b8e3f94c295c6257e61c7caa441d37f40a8f9ffa8d80a9db30a94"
    sha256 cellar: :any,                 arm64_sequoia:  "a06f88677a1fc1815127a1e75dcc3855a46f70b9e23333883a23f9635095b466"
    sha256 cellar: :any,                 arm64_sonoma:   "24937667b9315c47cc2ddda94564cda1e1d96cc023c38ecf73be04d14ce3f451"
    sha256 cellar: :any,                 arm64_ventura:  "2b988c5f0d11e5c32152fcdd31b760f5d76ad87518e17b08bef428de1637c68f"
    sha256 cellar: :any,                 arm64_monterey: "7d5a837843772eb893e746c3cba51dc03fcd976ebfef1ffd51823a6e880e5bcb"
    sha256 cellar: :any,                 sonoma:         "767d6bb0732fc7caf62d2a83cefd46e505ab1f26a1fe37fd74121716bae96945"
    sha256 cellar: :any,                 ventura:        "427b1ac8f16271a483e972b4a1ef5721d7bf0f200a9d4e49f42151dab276273a"
    sha256 cellar: :any,                 monterey:       "1ae379b34875e8a2deab485dbfc9716606ecba8f34267f979eb10e36ca474745"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "4335c5c6de511f66172229cfedec62145ddf1f408b48e14b732c457e861fd746"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd8ee6610e199b5cd9fbc20357597205bce8d7a9c92937e45ab0287ee11aa3fc"
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
    system bin/"uftp_keymgt"
  end
end
