class Wolfssl < Formula
  desc "Embedded SSL Library written in C"
  homepage "https://www.wolfssl.com"
  # Git checkout automatically enables extra hardening flags
  # Ref: https://github.com/wolfSSL/wolfssl/blob/master/m4/ax_harden_compiler_flags.m4#L71
  url "https://github.com/wolfSSL/wolfssl.git",
      tag:      "v5.7.6-stable",
      revision: "239b85c80438bf60d9a5b9e0ebe9ff097a760d0d"
  license "GPL-2.0-or-later"
  head "https://github.com/wolfSSL/wolfssl.git", branch: "master"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+)[._-]stable/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "279d3047b1e2989642f1b41d425271c367c3247e9498f30c9d896b29bfff937b"
    sha256 cellar: :any,                 arm64_sonoma:  "8552b5f3dcd75c63f5c889b8cbfb0c905f31d861fa7c52544437ad8c16d56581"
    sha256 cellar: :any,                 arm64_ventura: "49d9838fff32b81f23583f7786f3fffa71b075a8eeef272fb9403919fa29ba19"
    sha256 cellar: :any,                 sonoma:        "b45eb105ad94558596f602f16c144993d2c2a387a5f5d65c4c8fb217e9a41849"
    sha256 cellar: :any,                 ventura:       "e40361b9eda5db93e0027ecc80c3c272325238c2c2cbb3c48f69311271f6dac0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b3563b45e35cd04f63b626fa115d4a137e8e80ec4a3b08c31ed9da39aabb3a5"
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
