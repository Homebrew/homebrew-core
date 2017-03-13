class Sshguard < Formula
  desc "Protect from brute force attacks against SSH"
  homepage "https://www.sshguard.net/"
  url "https://downloads.sourceforge.net/project/sshguard/sshguard/2.0.0/sshguard-2.0.0.tar.gz"
  sha256 "e87c6c4a6dddf06f440ea76464eb6197869c0293f0a60ffa51f8a6a0d7b0cb06"
  version_scheme 1

  bottle do
    cellar :any_skip_relocation
    sha256 "2c125d21e3bd15476ee49dba004e0bdc694f8dbf16aa5b8d2753a8b700146e32" => :sierra
    sha256 "8ad59f971162f79c1a65c48238b07058a03256784a9283c0675c25f1d582dfde" => :el_capitan
    sha256 "20918ad422229e3d3fec35af56916d396963014b95341206bd1e905a3f553384" => :yosemite
  end

  depends_on "automake" => :build
  depends_on "autoconf" => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system "make", "install"
    mkdir "etc"
    cp "examples/sshguard.conf.sample", "etc/sshguard.conf"
    inreplace "etc/sshguard.conf" do |s|
      s.gsub! /^#BACKEND=.*$/, "BACKEND=\"#{libexec}/sshg-fw-#{firewall}\""
      if MacOS.version >= :sierra
        s.gsub! %r{^#LOGREADER="/usr\/bin\/log}, "LOGREADER=\"/usr/bin/log"
      else
        s.gsub! /^#FILES.*$/, "FILES=#{log_path}"
      end
    end
    etc.install "etc/sshguard.conf"
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
    assert_match version.to_s, shell_output("#{sbin}/sshguard -v 2>&1", 78)
  end
end
