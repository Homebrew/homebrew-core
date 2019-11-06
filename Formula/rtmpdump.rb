class Rtmpdump < Formula
  desc "Tool for downloading RTMP streaming media"
  homepage "https://rtmpdump.mplayerhq.hu/"
  url "https://deb.debian.org/debian/pool/main/r/rtmpdump/rtmpdump_2.4+20151223.gitfa8646d.1.orig.tar.gz"
  version "2.4+20151223"
  sha256 "5c032f5c8cc2937eb55a81a94effdfed3b0a0304b6376147b86f951e225e3ab5"
  revision 1
  head "https://git.ffmpeg.org/rtmpdump.git", :shallow => false

  bottle do
    cellar :any
    sha256 "f39d714005d28ed61728832877433a68dd256796bc225bac68b505b2c1d97ef4" => :catalina
    sha256 "97cf25d61d474c2115f6448940f924324d630b60776396398662b1368b4544da" => :mojave
    sha256 "7e95dc18fc03a6c1f19385e1507448f23e2e570c9b3ad60bd3fbc05c65295fb8" => :high_sierra
    sha256 "2118d007922d98ae71169be417106f594636e6ff979611b9e51dd2cf09c002b7" => :sierra
  end

  depends_on "openssl@1.1"

  conflicts_with "flvstreamer", :because => "both install 'rtmpsrv', 'rtmpsuck' and 'streams' binary"

  # Patch for OpenSSL 1.1 compatibility
  # Taken from https://github.com/JudgeZarbi/RTMPDump-OpenSSL-1.1
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/rtmpdump/openssl-1.1.diff"
    sha256 "3c9167e642faa9a72c1789e7e0fb1ff66adb11d721da4bd92e648cb206c4a2bd"
  end

  def install
    ENV.deparallelize
    system "make", "CC=#{ENV.cc}",
                   "XCFLAGS=#{ENV.cflags}",
                   "XLDFLAGS=#{ENV.ldflags}",
                   "MANDIR=#{man}",
                   "SYS=darwin",
                   "prefix=#{prefix}",
                   "sbindir=#{bin}",
                   "install"
  end

  test do
    system "#{bin}/rtmpdump", "-h"
  end
end
