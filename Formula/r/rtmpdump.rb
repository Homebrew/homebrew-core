class Rtmpdump < Formula
  desc "Tool for downloading RTMP streaming media"
  homepage "https://rtmpdump.mplayerhq.hu/"
  url "https://deb.debian.org/debian/pool/main/r/rtmpdump/rtmpdump_2.4+20151223.gitfa8646d.1.orig.tar.gz"
  mirror "http://deb.debian.org/debian/pool/main/r/rtmpdump/rtmpdump_2.4+20151223.gitfa8646d.1.orig.tar.gz"
  version "2.4-20151223"
  sha256 "5c032f5c8cc2937eb55a81a94effdfed3b0a0304b6376147b86f951e225e3ab5"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  revision 2
  head "https://git.ffmpeg.org/rtmpdump.git", branch: "master"

  livecheck do
    url "https://cdn-aws.deb.debian.org/debian/pool/main/r/rtmpdump/"
    regex(/href=.*?rtmpdump[._-]v?(\d+(?:[.+]\d+)+)[^"' >]*?\.orig\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "844c42dad1b70ce218beace8ec8c9a69063f60d46566041b8ab822d09654c142"
    sha256 cellar: :any,                 arm64_monterey: "b00c0b459c15c44c60bbf5e93e8ac904f41f5a009c4933b5c1a560ee3ac8809b"
    sha256 cellar: :any,                 arm64_big_sur:  "efd5066a0a1971c72167a0d41f2cce28d7f5f6e7c3a4d4a25f08c975f701f380"
    sha256 cellar: :any,                 ventura:        "9824a5809e7488bb78abaa463bb3db87d8d555dbd5412e075fda3deae312b392"
    sha256 cellar: :any,                 monterey:       "65a0f652a98a2bc04273ffd295c8dc8d7df500521d331f81ec6f893a77408d6b"
    sha256 cellar: :any,                 big_sur:        "c7e153578fd1b4f9470d2a1b8a6f69fbea745c2c93434cd5ac2fcd733ef7a61e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27df787dca1af5084474dfbd1adab5ffee58670a2a47f8f7cf9961abb56c8b37"
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
