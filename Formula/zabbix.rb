class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://cdn.zabbix.com/zabbix/sources/stable/5.0/zabbix-5.0.9.tar.gz"
  sha256 "2985a710ac8d1273464345b5b3cf6c9eaff1abde019f361e4eb0760a03807c9b"
  license "GPL-2.0-or-later"

  # As of writing, the Zabbix SourceForge repository is missing the latest
  # version (4.4.8), so we have to check for the newest version on the Zabbix
  # CDN index page instead. Unfortunately, the versions are separated into
  # folders for a given major/minor version, so this will quietly stop being
  # a proper check sometime in the future and need to be updated.
  livecheck do
    url "https://cdn.zabbix.com/zabbix/sources/stable/5.0/"
    regex(/href=.*?zabbix[._-](\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "c30636310e36dca63d94e9be9427fe9272db86fb0dae74f74763281a953619e7"
    sha256 big_sur:       "4cddb5bb01586c3d64fdd54f204890bf4b96aab385ca125b6954aa316e8de02d"
    sha256 catalina:      "917ad3387981bcc85a891924688bad4f818d8a9967ad0d39590d37da78f65a64"
    sha256 mojave:        "b9583dfd6e8ea3ee04ff21a9b73ff0b41bbea6eb0edb017dfe280c4c29d535d9"
  end

  depends_on "openssl@1.1"
  depends_on "pcre"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --sysconfdir=#{etc}/zabbix
      --enable-agent
      --with-libpcre=#{Formula["pcre"].opt_prefix}
      --with-openssl=#{Formula["openssl@1.1"].opt_prefix}
    ]

    on_macos do
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
