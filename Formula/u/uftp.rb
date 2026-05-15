class Uftp < Formula
  desc "Secure, reliable, efficient multicast file transfer program"
  homepage "https://uftp-multicast.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/uftp-multicast/source-tar/uftp-5.0.3.tar.gz"
  sha256 "cb8668c19b1f10bc63a16ffa893e205dc3ec86361037d477d8003260ebc40080"
  license "GPL-3.0-or-later" => { with: "openvpn-openssl-exception" }
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/uftp[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "20bcf042e42fdb5576c2bcbc895972de54d511aa63b33fd6e6ddcf5f2d7e1668"
    sha256 cellar: :any,                 arm64_sequoia: "d7165879dd7a43accfad123bcee88049be7f84012ab1e3960220b9f4c36dbcc3"
    sha256 cellar: :any,                 arm64_sonoma:  "cb399a936e3ae523d139053c07bdb3c098f17428ed698964cd11d7a2b617ad5e"
    sha256 cellar: :any,                 sonoma:        "fd5a228d1f1173e908110a14c1af035bb9842f228e100361aed9b523272305a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "181c7fa3e4940b4357f81bb9e2ace9fab9d61464d13e0f38966d8b962fcf933d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "723fad4459cb70a3c484db040c96331f5299b8e7d0aabbb4e13e51d4933ee1c7"
  end

  depends_on "openssl@4"

  def install
    system "make", "OPENSSL=#{Formula["openssl@4"].opt_prefix}", "DESTDIR=#{prefix}", "install"
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
