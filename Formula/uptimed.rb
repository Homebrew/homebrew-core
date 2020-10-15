class Uptimed < Formula
  desc "Utility to track your highest uptimes"
  homepage "https://github.com/rpodgorny/uptimed/"
  url "https://github.com/rpodgorny/uptimed/archive/v0.4.3.tar.gz"
  sha256 "11add61c39cb2a50f604266104c5ceb291ab830939ed7c84659c309be1e1e715"
  license "GPL-2.0-only"

  bottle do
    cellar :any
    sha256 "1e20c4955ff14a05da57be77e08e163e164e41995411c21aeaa5a5bf3919fb7c" => :catalina
    sha256 "d5d96957debd223a243d71dc0d9858d19179c94841f6640822b1db841c0bfd48" => :mojave
    sha256 "8585595184bf697772b292e123f63c97513e242c7d04194c9e1990d60fcef571" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    # Per MacPorts
    inreplace "Makefile", "/var/spool/uptimed", "#{var}/uptimed"
    inreplace "libuptimed/urec.h", "/var/spool", var
    inreplace "etc/uptimed.conf-dist", "/var/run", "#{var}/uptimed"
    system "make", "install"
  end

  plist_options manual: "uptimed"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>RunAtLoad</key>
          <true/>
          <key>KeepAlive</key>
          <false/>
          <key>WorkingDirectory</key>
          <string>#{opt_prefix}</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_sbin}/uptimed</string>
            <string>-f</string>
            <string>-p</string>
            <string>#{var}/run/uptimed.pid</string>
          </array>
        </dict>
      </plist>
    EOS
  end

  test do
    system "#{sbin}/uptimed", "-t", "0"
    sleep 2
    output = shell_output("#{bin}/uprecords -s")
    assert_match /->\s+\d+\s+\d+\w,\s+\d+:\d+:\d+\s+|.*/, output, "Uptime returned is invalid"
  end
end
