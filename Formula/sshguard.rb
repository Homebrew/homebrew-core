class Sshguard < Formula
  desc "Protect from brute force attacks against SSH"
  homepage "https://www.sshguard.net/"
  url "https://downloads.sourceforge.net/project/sshguard/sshguard/2.4.0/sshguard-2.4.0.tar.gz"
  sha256 "065ca4091b3a96802714b560dbbc3d9f0e67574e99e2b6e8857aa1027d17d6c0"
  version_scheme 1

  bottle do
    cellar :any_skip_relocation
    sha256 "3cd89e0a19db4220d583cd5404931b48a0564e0febc5236dceb308f34ccfc970" => :mojave
    sha256 "924436fc182a6d79a0f4e2461b25f4aca1aa57c48bb2db049ae1fbe0f115cdab" => :high_sierra
    sha256 "37b791a9417754e5db8f1665b2982bd6a8421927b73950d520af0c9eb369c474" => :sierra
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
      begin
        assert_equal "SSHGuard #{version}", r.read.strip
      ensure
        Process.wait pid
      end
    end
  end
end
