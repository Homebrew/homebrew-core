class Rtmpdump < Formula
  desc "Tool for downloading RTMP streaming media"
  homepage "https://rtmpdump.mplayerhq.hu/"
  url "https://git.ffmpeg.org/rtmpdump.git",
      tag:      "v2.6",
      revision: "138fdb258d9fc26f1843fd1b891180416c9dc575"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  revision 1
  compatibility_version 1
  head "https://git.ffmpeg.org/rtmpdump.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9e82c204f24b38ab4fd9e0b706cf3e6edc4ef352e9f80c2a69eb2b3ce551fecf"
    sha256 cellar: :any,                 arm64_sequoia: "be2e0bb5e18a85fe2bd42492a5a09d43f95a97a051cba4feefa2e92b5a8e8b29"
    sha256 cellar: :any,                 arm64_sonoma:  "18f2f6ea084a9387e826392dfb6c610e8c7aa6813ef582b82af30c95cf1da41d"
    sha256 cellar: :any,                 sonoma:        "c22bd9ef3ed2e216bc3f62d95a1c79f8db58198123f03bd0809646ad69dd9c41"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "262cdbe4025f22936097bf830e01c822819ac800572c18299d11a00ac6a79d0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "842e5f794e8b746f103fb4cd20f5911e5ff54e8faa27c5d6263ae11be1c74f69"
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
