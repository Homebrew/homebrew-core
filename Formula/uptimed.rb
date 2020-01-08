class Uptimed < Formula
  desc "Utility to track your highest uptimes"
  homepage "https://github.com/rpodgorny/uptimed/"
  url "https://github.com/rpodgorny/uptimed/archive/v0.4.2.tar.gz"
  sha256 "5f803eccc1247b4a22171de4670a896e05adb9a82f018facda1b2cc5b19dbc97"

  bottle do
    cellar :any
    sha256 "8a60913d8acaf592560c0b6f42b77cd83b69adf5fbeee77e0e095f7e4b413f65" => :catalina
    sha256 "ed7ff6b62654f5514d2657f07ed2dc83d5046a2219eb651b6423609fac961f28" => :mojave
    sha256 "128fb7d767fc12e12917cbc761a942158f0fd75a5a9e209508670287cb5d00ed" => :high_sierra
    sha256 "195a89c67e7e09ba690f1cfc8fd91ce07d0623ca9b5da4f2fc70dc7f1f81c9a7" => :sierra
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

  plist_options :manual => "uptimed"

  def plist; <<~EOS
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
