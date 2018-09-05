class Uptimed < Formula
  desc "Utility to track your highest uptimes"
  homepage "https://github.com/rpodgorny/uptimed/"
  url "https://github.com/rpodgorny/uptimed/archive/v0.4.1.tar.gz"
  sha256 "01b16519bbdd3b99c97a09e910b74e4dceb5eea74e3ab20b6c90c76c8cb55905"

  bottle do
    sha256 "607e02ebcebdeb8413890a529bc3b2a74e886dc8ba530b87be890519e8c3a8f4" => :mojave
    sha256 "7dda8cf4cbda86ba76db57c3352b916726da78640e656c49edf5c8b63441a817" => :high_sierra
    sha256 "01e1e14e4af2adc149ef379042fbb223fd9ce27fbc7f2b0e4711088c90bf9dd1" => :sierra
    sha256 "9b0d74450aa29f5fbbc1f6d2749b9d35c9af37e4594c88b53bb4c950a7c4c73b" => :el_capitan
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
