class Sshguard < Formula
  desc "Protect from brute force attacks against SSH"
  homepage "https://www.sshguard.net/"
  url "https://downloads.sourceforge.net/project/sshguard/sshguard/2.0.0/sshguard-2.0.0.tar.gz"
  sha256 "e87c6c4a6dddf06f440ea76464eb6197869c0293f0a60ffa51f8a6a0d7b0cb06"
  revision 2
  version_scheme 1

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "e764fa15ad0d10efc397f903615ef1c6507574938d9ccc2f57b1fd32ad949e39" => :high_sierra
    sha256 "87d6c9a576f06394b76c57837e1fdd700a48a58a720a546acc013818eb341e79" => :sierra
    sha256 "dc712e331dd208b919076b5c4317809f081a274460dde1c3fd3d0226463fe32f" => :el_capitan
    sha256 "dd5cfdc92ff81e8dc725ed3e263e0e1358149a3298bb9803c39a50d045e17421" => :yosemite
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
    cp "examples/sshguard.conf.sample", "examples/sshguard.conf"
    inreplace "examples/sshguard.conf" do |s|
      s.gsub! /^#BACKEND=.*$/, "BACKEND=\"#{opt_libexec}/sshg-fw-#{firewall}\""
      if MacOS.version == :sierra
        s.gsub! %r{^#LOGREADER="/usr/bin/log}, "LOGREADER=\"/usr/bin/log"
      else
        s.gsub! /^#FILES.*$/, "FILES=#{log_path}"
      end
    end
    etc.install "examples/sshguard.conf"
  end

  def firewall
    (MacOS.version >= :lion) ? "pf" : "ipfw"
  end

  def log_path
    (MacOS.version >= :lion) ? "/var/log/system.log" : "/var/log/secure.log"
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
