class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://cdn.zabbix.com/zabbix/sources/stable/5.0/zabbix-5.0.7.tar.gz"
  sha256 "d762f8a9aa9e8717d2e85d2a82d27316ea5c2b214eb00aff41b6e9b06107916a"
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
    sha256 "939012c09a3f42715f144c554861da78f1797d3709834e255106e8e4e7004aa8" => :big_sur
    sha256 "c5cc517392f6d602ff395d594b5433e6f8ae8f49fdbddb3091b5234846a260bc" => :arm64_big_sur
    sha256 "e3f61c3f455e4d762854b6d95ad65a0b23c058ea8d547ca3ad44e8479e42e3db" => :catalina
    sha256 "bd1a49553de2aa8ce79da4841f2d2614142d9ae0c0cb6785c241e4f2a4908fce" => :mojave
  end

  depends_on "openssl@1.1"
  depends_on "pcre"

  def brewed_or_shipped(db_config)
    brewed_db_config = "#{HOMEBREW_PREFIX}/bin/#{db_config}"
    (File.exist?(brewed_db_config) && brewed_db_config) || which(db_config)
  end

  def install
    sdk = MacOS::CLT.installed? ? "" : MacOS.sdk_path

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --sysconfdir=#{etc}/zabbix
      --enable-agent
      --with-iconv=#{sdk}/usr
      --with-libpcre=#{Formula["pcre"].opt_prefix}
      --with-openssl=#{Formula["openssl@1.1"].opt_prefix}
    ]

    if MacOS.version == :el_capitan && MacOS::Xcode.version >= "8.0"
      inreplace "configure", "clock_gettime(CLOCK_REALTIME, &tp);",
                             "undefinedgibberish(CLOCK_REALTIME, &tp);"
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    system sbin/"zabbix_agentd", "--print"
  end
end
