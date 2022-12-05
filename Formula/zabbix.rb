class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://cdn.zabbix.com/zabbix/sources/stable/6.2/zabbix-6.2.6.tar.gz"
  sha256 "ae40c8cd4b24159466a7483e65f85836a8c963a0bc394a3dd890142aaf30ac17"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }
  head "https://github.com/zabbix/zabbix.git", branch: "master"

  livecheck do
    url "https://www.zabbix.com/download_sources"
    regex(/href=.*?zabbix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "63fcf78bbc2e3dca7127c2316be879a68e150a1460ec5f75643b5515f99150ee"
    sha256 arm64_monterey: "eb429110687fc6865454f27fbd7596e30995681906145aa1833565f3e7156b86"
    sha256 arm64_big_sur:  "af8bbdcd05138e1c1df5512192b30bc5eb5054cba039415dc683f81d00f04ec1"
    sha256 ventura:        "c9035eecd0c6a192264582b3a13172d9d082a73b6c998121116b56cf27be8266"
    sha256 monterey:       "94e15038974c22e52525d934391f4b9fd6527bf166290f5414a7e16fa5d18357"
    sha256 big_sur:        "af29d616a8b223ea934c2ad49a2334fe37928dfa2f4c3759d5bc81568849c05d"
    sha256 catalina:       "024235ee0bc43872e6665eff62f6613ac9d16b44fc2e63c43bd3282e381a9093"
    sha256 x86_64_linux:   "45bc70c6094badff200f45e8c1e84a5b49956459ab1a4ae6b639c8f1b3783113"
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@3"
  depends_on "pcre2"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --sysconfdir=#{etc}/zabbix
      --enable-agent
      --with-libpcre2
      --with-openssl=#{Formula["openssl@3"].opt_prefix}
    ]

    if OS.mac?
      sdk = MacOS::CLT.installed? ? "" : MacOS.sdk_path
      args << "--with-iconv=#{sdk}/usr"
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    system sbin/"zabbix_agentd", "--print"
  end
end
