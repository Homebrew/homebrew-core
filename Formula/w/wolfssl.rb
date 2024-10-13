class Wolfssl < Formula
  desc "Embedded SSL Library written in C"
  homepage "https://www.wolfssl.com"
  # Git checkout automatically enables extra hardening flags
  # Ref: https://github.com/wolfSSL/wolfssl/blob/master/m4/ax_harden_compiler_flags.m4#L71
  url "https://github.com/wolfSSL/wolfssl.git",
      tag:      "v5.7.2-stable",
      revision: "00e42151ca061463ba6a95adb2290f678cbca472"
  license "GPL-2.0-or-later"
  head "https://github.com/wolfSSL/wolfssl.git", branch: "master"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+)[._-]stable/i)
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "d07a7c52d7e59676792ea018eb09fad452fe3147001508b7429d3559a89df89e"
    sha256 cellar: :any,                 arm64_sonoma:  "51a294f32eb2cf6b8fdf9a9aac20d47ad7f900931e7ca546e4bfb83eeaf65b9c"
    sha256 cellar: :any,                 arm64_ventura: "333381bb23e3380f5ba383ff840f8673168a84e65fcc7a638c6edb026749991d"
    sha256 cellar: :any,                 sonoma:        "38cc88e6b2d44a4d11afc3b90848ebde674bf05b134194daf6c92f07681c822f"
    sha256 cellar: :any,                 ventura:       "2eb3552dfc9430bd8f294c8063d74ff23dcacfd78614d32e663d52d21f250b4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91cb773b21faf9198f536ed281ee0ac6a7758162f824553c533ed1be194dc951"
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
