class Rtmpdump < Formula
  desc "Tool for downloading RTMP streaming media"
  homepage "https://rtmpdump.mplayerhq.hu/"
  url "https://deb.debian.org/debian/pool/main/r/rtmpdump/rtmpdump_2.4+20151223.gitfa8646d.1.orig.tar.gz"
  mirror "http://deb.debian.org/debian/pool/main/r/rtmpdump/rtmpdump_2.4+20151223.gitfa8646d.1.orig.tar.gz"
  version "2.4+20151223"
  sha256 "5c032f5c8cc2937eb55a81a94effdfed3b0a0304b6376147b86f951e225e3ab5"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  revision 1
  head "https://git.ffmpeg.org/rtmpdump.git"

  livecheck do
    url "https://cdn-aws.deb.debian.org/debian/pool/main/r/rtmpdump/"
    regex(/href=.*?rtmpdump[._-]v?(\d+(?:[.+]\d+)+)[^"' >]*?\.orig\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f0787745f3b2ac7c173b3582b7079a2f30ad82dcad69a34fb79edf76e804dbb2"
    sha256 cellar: :any,                 arm64_big_sur:  "67c47ecf95d2f4367685fb0ab04c913d55743e5bafccce721f665c6579f3b599"
    sha256 cellar: :any,                 monterey:       "f85231e41536d97be7e733be388641ddc32e7c3fd32d07437760ea69a0298778"
    sha256 cellar: :any,                 big_sur:        "b9e42bf8023a8634a741402f7f902bbd0083e663b2e0d36d3e70dec657f1dd07"
    sha256 cellar: :any,                 catalina:       "f39d714005d28ed61728832877433a68dd256796bc225bac68b505b2c1d97ef4"
    sha256 cellar: :any,                 mojave:         "97cf25d61d474c2115f6448940f924324d630b60776396398662b1368b4544da"
    sha256 cellar: :any,                 high_sierra:    "7e95dc18fc03a6c1f19385e1507448f23e2e570c9b3ad60bd3fbc05c65295fb8"
    sha256 cellar: :any,                 sierra:         "2118d007922d98ae71169be417106f594636e6ff979611b9e51dd2cf09c002b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c1d50c3dc8938a0e69c86d29046c924c3e9f7d80c567c8bd848fe368ae0a992e"
  end

  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  conflicts_with "flvstreamer", because: "both install 'rtmpsrv', 'rtmpsuck' and 'streams' binary"

  # Patch for OpenSSL 1.1 compatibility
  # Taken from https://github.com/JudgeZarbi/RTMPDump-OpenSSL-1.1
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/rtmpdump/openssl-1.1.diff"
    sha256 "3c9167e642faa9a72c1789e7e0fb1ff66adb11d721da4bd92e648cb206c4a2bd"
  end

  def install
    ENV.deparallelize

    os = if OS.mac?
      "darwin"
    else
      "posix"
    end

    system "make", "CC=#{ENV.cc}",
                   "XCFLAGS=#{ENV.cflags}",
                   "XLDFLAGS=#{ENV.ldflags}",
                   "MANDIR=#{man}",
                   "SYS=#{os}",
                   "prefix=#{prefix}",
                   "sbindir=#{bin}",
                   "install"
  end

  test do
    system "#{bin}/rtmpdump", "-h"
  end
end
