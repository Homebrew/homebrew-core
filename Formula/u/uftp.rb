class Uftp < Formula
  desc "Secure, reliable, efficient multicast file transfer program"
  homepage "https://uftp-multicast.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/uftp-multicast/source-tar/uftp-5.0.4.tar.gz"
  sha256 "50df3f0e59ebd59ed1b9bc8af991a0187df14d928188ff5f62c3d65adcd113ab"
  license "GPL-3.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :stable
    regex(%r{url=.*?/uftp[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "535007a39bbebae49254a421b6c89dc99526e7d347c4aafdc3744af257223046"
    sha256 cellar: :any, arm64_tahoe:       "bfb1c112ec39c391a4a4b81464105f853bedc1cdf848e79e33fedd018cddc738"
    sha256 cellar: :any, arm64_sequoia:     "997d48fe3ab6d8ba615b10a158713fe12b95ab246ae0cda58c9ea27dca60c4f4"
    sha256 cellar: :any, arm64_linux:       "9479a6d96d509a30df78f82f5c950b7aa7612f618c579f7d8a185ded9b7673e4"
    sha256 cellar: :any, x86_64_linux:      "debad6d8877f01b161f10d4f32ea4bba3b8caa2cef038ccf613be27db367f792"
  end

  depends_on "openssl@4"

  def install
    system "make", "OPENSSL=#{formula_opt_prefix("openssl@4")}", "DESTDIR=#{prefix}", "install"
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
