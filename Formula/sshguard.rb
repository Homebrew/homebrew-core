class Sshguard < Formula
  desc "Protect from brute force attacks against SSH"
  homepage "http://www.sshguard.net/"
  url "https://downloads.sourceforge.net/project/sshguard/sshguard/1.99.0/sshguard-1.99.0.tar.gz"
  sha256 "d55ec6f57c24d954998328e0363000dbded9aed0580cfe4b558fce0abe550f95"

  bottle do
    cellar :any_skip_relocation
    sha256 "c6a823b4e8134a3783900637d3d819c9b9a6f5982a65fe361033c08374109e48" => :sierra
    sha256 "755d2dd4248792f3d0eb11d808613be53e8c96c819e742d3350e36a793dbac5a" => :el_capitan
    sha256 "bcd1b2cf6f8a9463c09320a9f8d3f806d79ad631afdc7ca8b3ac42c7d721a866" => :yosemite
  end

  depends_on "automake" => :build
  depends_on "autoconf" => :build

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-firewall=#{firewall}"
    system "make", "install"
  end

  def firewall
    MacOS.version >= :lion ? "pf" : "ipfw"
  end

  def log_path
    MacOS.version >= :lion ? "/var/log/system.log" : "/var/log/secure.log"
  end

  def caveats
    if MacOS.version >= :lion then <<-EOS.undent
      Add the following lines to /etc/pf.conf to block entries in the sshguard
      table (replace $ext_if with your WAN interface):

        table <sshguard> persist
        block in quick on $ext_if proto tcp from <sshguard> to any port 22 label "ssh bruteforce"

      Then run sudo pfctl -f /etc/pf.conf to reload the rules.
      EOS
    end
  end

  plist_options :startup => true

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>KeepAlive</key>
      <true/>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_sbin}/sshguard</string>
        <string>-l</string>
        <string>#{log_path}</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
    </dict>
    </plist>
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{sbin}/sshguard -v 2>&1", 78)
  end
end
