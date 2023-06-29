class Rtmpdump < Formula
  desc "Tool for downloading RTMP streaming media"
  homepage "https://rtmpdump.mplayerhq.hu/"
  url "https://deb.debian.org/debian/pool/main/r/rtmpdump/rtmpdump_2.4+20151223.gitfa8646d.1.orig.tar.gz"
  mirror "http://deb.debian.org/debian/pool/main/r/rtmpdump/rtmpdump_2.4+20151223.gitfa8646d.1.orig.tar.gz"
  version "2.4+20151223"
  sha256 "5c032f5c8cc2937eb55a81a94effdfed3b0a0304b6376147b86f951e225e3ab5"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  revision 2
  head "https://git.ffmpeg.org/rtmpdump.git", branch: "master"

  livecheck do
    url "https://cdn-aws.deb.debian.org/debian/pool/main/r/rtmpdump/"
    regex(/href=.*?rtmpdump[._-]v?(\d+(?:[.+]\d+)+)[^"' >]*?\.orig\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "572f37c44c4f32aa13dcd2bbf4770ec3e95ac469301044e61b1e36504c272f4e"
    sha256 cellar: :any,                 arm64_monterey: "9485c20cdb3af897739b7f96d1277b067f8942ec56319d63723f553c9bba83b2"
    sha256 cellar: :any,                 arm64_big_sur:  "296c88c93a14ef83e9423e17c6a68ab4433b40f52c298a638fad8b04d8a47d00"
    sha256 cellar: :any,                 ventura:        "d55211ce185ffec9901ae510de102b69e210e2b978e0cef81e0ea4e7de9f8266"
    sha256 cellar: :any,                 monterey:       "92ff849dd16c09569ede4c04e8cab4679366c4d3fabe47dc97733ae89aee24bb"
    sha256 cellar: :any,                 big_sur:        "898c06791665ad0c74e4b7ba99451b47402b3a22c02f98166ffb7d2258d77a35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d051297b563e80fbcff1a9006ae9fa0ce66280716322fa58a669298d73407e6f"
  end

  depends_on "openssl@3"

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
