class Rtmpdump < Formula
  desc "Tool for downloading RTMP streaming media"
  homepage "https://rtmpdump.mplayerhq.hu/"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/r/rtmpdump/rtmpdump_2.4+20151223.gitfa8646d.1.orig.tar.gz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/r/rtmpdump/rtmpdump_2.4%2b20151223.gitfa8646d.1.orig.tar.gz"
  version "2.4+20151223"
  sha256 "5c032f5c8cc2937eb55a81a94effdfed3b0a0304b6376147b86f951e225e3ab5"
  head "https://git.ffmpeg.org/rtmpdump", :shallow => false

  bottle do
    cellar :any
    sha256 "e7c562912842233146c49e8510cf5a6024d098ee41202cabe1e25805c32c1ed1" => :mojave
    sha256 "29e7fd835f6a5bc724d953bab6d06fa6e22f860ebc7b74f9b14a948fb0081c77" => :high_sierra
    sha256 "2d3310f9a53bdf34ca144e9c58febe74f80253ac518a4c350471ca65591b7f1c" => :sierra
    sha256 "f05e64f75ae79fcfe021be7b39112ea3aac53d8d1ca22bfaa658bbf161c84675" => :el_capitan
    sha256 "c7a1bb0f9b2f7c194533a42ade11086fcb03a8bfaf76d479ae22ca4b0d107f20" => :yosemite
    sha256 "f4c8dbdf3f8a04626a7975abf96eccd5e494a3f6a795b2035c6d418bfbe8079d" => :mavericks
  end

  depends_on "openssl"

  conflicts_with "flvstreamer", :because => "both install 'rtmpsrv', 'rtmpsuck' and 'streams' binary"

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
