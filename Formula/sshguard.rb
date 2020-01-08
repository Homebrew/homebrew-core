class Sshguard < Formula
  desc "Protect from brute force attacks against SSH"
  homepage "https://www.sshguard.net/"
  url "https://downloads.sourceforge.net/project/sshguard/sshguard/2.4.0/sshguard-2.4.0.tar.gz"
  sha256 "065ca4091b3a96802714b560dbbc3d9f0e67574e99e2b6e8857aa1027d17d6c0"
  version_scheme 1

  bottle do
    cellar :any_skip_relocation
    sha256 "033c09dbb290b68e8b33ce6709fba3b8764342af4b1ddac8d91b4e63973caea0" => :catalina
    sha256 "63af5b9fe223253a1798e8500475af1675c8a36d987628b9e195a5da33bad252" => :mojave
    sha256 "54bb8831aaf7de0a2ba0ee3780e34a76dd67e90d3db8bcf5e3496ec78e4d5b56" => :high_sierra
    sha256 "94c8ecf69111d23d51cc2e61ecfc0438dd9006236340e659ed094b8d7e3fd699" => :sierra
  end

  head do
    url "https://bitbucket.org/sshguard/sshguard.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "docutils" => :build
  end

  def install
    system "autoreconf", "-fiv" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system "make", "install"
    inreplace man8/"sshguard.8", "%PREFIX%/etc/", "#{etc}/"
    cp "examples/sshguard.conf.sample", "examples/sshguard.conf"
    inreplace "examples/sshguard.conf" do |s|
      s.gsub! /^#BACKEND=.*$/, "BACKEND=\"#{opt_libexec}/sshg-fw-pf\""
      if MacOS.version >= :sierra
        s.gsub! %r{^#LOGREADER="/usr/bin/log}, "LOGREADER=\"/usr/bin/log"
      else
        s.gsub! /^#FILES.*$/, "FILES=/var/log/system.log"
      end
    end
    etc.install "examples/sshguard.conf"
  end

  def caveats
    <<~EOS
      Add the following lines to /etc/pf.conf to block entries in the sshguard
      table (replace $ext_if with your WAN interface):

        table <sshguard> persist
        block in quick on $ext_if proto tcp from <sshguard> to any port 22 label "ssh bruteforce"

      Then run sudo pfctl -f /etc/pf.conf to reload the rules.
    EOS
  end

  plist_options :startup => true

  def plist; <<~EOS
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
    require "pty"
    PTY.spawn(sbin/"sshguard", "-v") do |r, _w, pid|
      assert_equal "SSHGuard #{version}", r.read.strip
    ensure
      Process.wait pid
    end
  end
end
