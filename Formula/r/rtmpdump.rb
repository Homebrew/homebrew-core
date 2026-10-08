class Rtmpdump < Formula
  desc "Tool for downloading RTMP streaming media"
  homepage "https://rtmpdump.mplayerhq.hu/"
  url "git://git.ffmpeg.org/rtmpdump.git",
      tag:      "v2.6",
      revision: "138fdb258d9fc26f1843fd1b891180416c9dc575"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  revision 2
  compatibility_version 1
  head "git://git.ffmpeg.org/rtmpdump.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "2e68aa9521c8b2a3701128c07e6e32fa826a1a485401014735ef57c5a1a84a10"
    sha256 cellar: :any, arm64_tahoe:       "821e2455e7920733f38c766cb53ade2724e88987bd1e22b9fdce1540f8edc20b"
    sha256 cellar: :any, arm64_sequoia:     "c456358649bdfcd817cb89a2d7da1fc0f0bb6b0c50265e44a43c3987ed02c535"
    sha256 cellar: :any, arm64_linux:       "3e7dc5e1de573721e652c737f9f04e164a2ecb6a6a7b21819d231cfa8b9422ca"
    sha256 cellar: :any, x86_64_linux:      "2742eca7b4267e1398476a434e4f145b06edb8ab0369da9274be86260c969f45"
  end

  depends_on "openssl@4"

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
