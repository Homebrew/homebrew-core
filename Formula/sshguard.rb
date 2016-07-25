class Sshguard < Formula
  desc "Protect from brute force attacks against SSH"
  homepage "http://www.sshguard.net/"
  url "https://downloads.sourceforge.net/project/sshguard/sshguard/1.6.4/sshguard-1.6.4.tar.gz"
  sha256 "654d5412ed010e500e2715ddeebfda57ab23c47a2bd30dfdc1e68c4f04c912a9"

  bottle do
    cellar :any_skip_relocation
    sha256 "cd2a21d2b45af181adc43f52a7be536e776c635f2f0ae9e24625a54ce00883fe" => :el_capitan
    sha256 "3a6ac732f48047afb5ebc169d7b24b33439a9b87ed7c8eb3686c3a8cf595b6b0" => :yosemite
    sha256 "535afed1333998dd1b80eb8a2d3da16a5fee41e8d18fa47e55ec8f8b13e239b3" => :mavericks
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
    assert_match version.to_s, shell_output("#{sbin}/sshguard -v 2>&1", 64)
  end
end
