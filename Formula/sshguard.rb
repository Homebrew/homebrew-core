class Sshguard < Formula
  desc "Protect from brute force attacks against SSH"
  homepage "https://www.sshguard.net/"
  url "https://downloads.sourceforge.net/project/sshguard/sshguard/2.0.0/sshguard-2.0.0.tar.gz"
  sha256 "e87c6c4a6dddf06f440ea76464eb6197869c0293f0a60ffa51f8a6a0d7b0cb06"
  version_scheme 1
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "8a0e7842c9f1fc96dd135086b653b1fefe45353cbf630fb560f8852ea6aa91a0" => :sierra
    sha256 "00091e528d72236eaa0f71a384f6ddd006349e36f9e3ac46b3bd2cf57941faeb" => :el_capitan
    sha256 "280351ac89ad14d0b1aa589779d60c024bb1821d08571044a689c6aae39193d4" => :yosemite
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system "make", "install"
    cp "examples/sshguard.conf.sample", "examples/sshguard.conf"
    inreplace "examples/sshguard.conf" do |s|
      s.gsub! /^#BACKEND=.*$/, "BACKEND=\"#{libexec}/sshg-fw-#{firewall}\""
      if MacOS.version >= :sierra
        s.gsub! %r{^#LOGREADER="/usr/bin/log}, "LOGREADER=\"/usr/bin/log"
      else
        s.gsub! /^#FILES.*$/, "FILES=#{log_path}"
      end
    end
    etc.install "examples/sshguard.conf"
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
      </array>
      <key>RunAtLoad</key>
      <true/>
    </dict>
    </plist>
    EOS
  end

  test do
    assert_match "SSHGuard #{version}", shell_output("#{sbin}/sshguard -v 2>&1")
  end
end
