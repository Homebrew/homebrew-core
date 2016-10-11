class Udpxy < Formula
  desc "UDP-to-HTTP multicast traffic relay daemon"
  homepage "http://www.udpxy.com/"
  url "http://www.udpxy.com/download/1_23/udpxy.1.0.23-9-prod.tar.gz"
  sha256 "6ce33b1d14a1aeab4bd2566aca112e41943df4d002a7678d9a715108e6b714bd"
  version "1.0.23-9"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "856dd5abfc350e8ce06e361664c21732e0b11dfd84aca7f9bd1e0e40704ccb67" => :sierra
    sha256 "6f2fb0a9baf932d599fca41b8ec80cd35491332ab89464bdda6d7ac8e5b5e01d" => :el_capitan
    sha256 "7624631dffaa797191689b05fcb5d7c87c0ad233e49c308b10462c08c8a955e4" => :yosemite
    sha256 "45dcc2c1a7d1f0170ae44edf600fee1f6112fd1e11530548a7e3b1870d71a7d8" => :mavericks
  end

  # Fix gzip path in Makefile for uname Darwin, this is needed to fix the install task
  # https://sourceforge.net/p/udpxy/patches/4/
  patch :DATA

  def install
    system "make"
    system "make", "install", "DESTDIR=#{prefix}", "PREFIX=''"
  end

  plist_options :manual => "udpxy -p 4022"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>KeepAlive</key>
      <true/>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/udpxy</string>
        <string>-p</string>
        <string>4022</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>WorkingDirectory</key>
      <string>#{HOMEBREW_PREFIX}</string>
    </dict>
    </plist>
    EOS
  end
end

__END__
--- a/Makefile 2014-07-31 18:40:40.000000000 +0200
+++ b/Makefile 2014-07-31 18:41:05.000000000 +0200
@@ -32,7 +32,9 @@
 ALL_FLAGS = -W -Wall -Werror --pedantic $(CFLAGS)

 SYSTEM=$(shell uname 2>/dev/null)
-ifeq ($(SYSTEM), FreeBSD)
+ifeq ($(SYSTEM), Darwin)
+GZIP := /usr/bin/gzip
+else ifeq ($(SYSTEM), FreeBSD)
 MAKE := gmake
 GZIP := /usr/bin/gzip
 endif
