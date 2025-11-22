class Wolfssl < Formula
  desc "Embedded SSL Library written in C"
  homepage "https://www.wolfssl.com"
  # Git checkout automatically enables extra hardening flags
  # Ref: https://github.com/wolfSSL/wolfssl/blob/master/m4/ax_harden_compiler_flags.m4#L71
  url "https://github.com/wolfSSL/wolfssl.git",
      tag:      "v5.8.4-stable",
      revision: "59f4fa568615396fbf381b073b220d1e8d61e4c2"
  license "GPL-3.0-or-later"
  head "https://github.com/wolfSSL/wolfssl.git", branch: "master"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+)[._-]stable/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "aac59ca422bfd4b3afdb4e4e846c6700b2931c457f2e77cdfa0ab5641c51b15e"
    sha256 cellar: :any,                 arm64_sequoia: "20575c7f7dd99423e435d5c2df0f95fa01ca698f647a31d64a6514b541c7848b"
    sha256 cellar: :any,                 arm64_sonoma:  "57cd97287c66a5c3ac7f566c1abe0ad7ff498e0b285f2114b618cde0312d2a1b"
    sha256 cellar: :any,                 sonoma:        "eace8310951249626c7787c6644225f7ca9e02b6a8a24482a64010ffdae0a0a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8bdab55e7c24c08b30f3c2895c2679bffa142b86cf3fef8ddb4f77bb0bbbf5ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1887e79717741ae67f1af8185bc009de75228a952e1bbb02bad3fccf9951ca4b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    args = %W[
      --infodir=#{info}
      --mandir=#{man}
      --sysconfdir=#{etc}
      --disable-bump
      --disable-earlydata
      --disable-examples
      --disable-fortress
      --disable-md5
      --disable-silent-rules
      --disable-sniffer
      --disable-webserver
      --enable-all
      --enable-reproducible-build
    ]

    # https://github.com/wolfSSL/wolfssl/issues/8148
    args << "--disable-armasm" if OS.linux? && Hardware::CPU.arm?

    # Extra flag is stated as a needed for the Mac platform.
    # https://www.wolfssl.com/docs/wolfssl-manual/ch2/
    # Also, only applies if fastmath is enabled.
    ENV.append_to_cflags "-mdynamic-no-pic" if OS.mac?

    system "./autogen.sh"
    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    system bin/"wolfssl-config", "--cflags", "--libs", "--prefix"
  end
end
