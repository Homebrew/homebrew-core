class Rtmpdump < Formula
  desc "Tool for downloading RTMP streaming media"
  homepage "https://rtmpdump.mplayerhq.hu/"
  url "https://git.ffmpeg.org/rtmpdump.git",
      tag:      "v2.6",
      revision: "138fdb258d9fc26f1843fd1b891180416c9dc575"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  head "https://git.ffmpeg.org/rtmpdump.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "488ebaf2932cd02770654ecaf903c115a2f21606d1e7eb37b87054c08f63486e"
    sha256 cellar: :any,                 arm64_sequoia: "dbae365bd1a8c9299b123dbb8557042c43332921b7c71496e0dedf554617ab29"
    sha256 cellar: :any,                 arm64_sonoma:  "717373dde83a7c0140831a1fa33b718dc71600c1d93759ddb10baf7d60afe245"
    sha256 cellar: :any,                 sonoma:        "89c063d3d0b8bb6d8a63c5cc47a3ace403dee9c99bd3d10e3c1e8efd58ee3bb3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18c6bc27daf24689a704d66342892097754843e402d591e5957086d5427a61ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5d37b5e7d3831124a9beea1f7fde55e593ffd12357007671ddb402642a4e009"
  end

  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with "flvstreamer", because: "both install 'rtmpsrv', 'rtmpsuck' and 'streams' binary"

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
    system bin/"rtmpdump", "-h"
  end
end
