class Wolfssl < Formula
  desc "Embedded SSL Library written in C"
  homepage "https://www.wolfssl.com"
  # Git checkout automatically enables extra hardening flags
  # Ref: https://github.com/wolfSSL/wolfssl/blob/master/m4/ax_harden_compiler_flags.m4#L71
  url "https://github.com/wolfSSL/wolfssl.git",
      tag:      "v5.9.1-stable",
      revision: "1d363f3adceba9d1478230ede476a37b0dcdef24"
  license "GPL-3.0-or-later"
  head "https://github.com/wolfSSL/wolfssl.git", branch: "master"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+)[._-]stable/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "591870f66e1d140d21a7c001ac99ce06e98b472cdb253535db0e9c5b1ec4b166"
    sha256 cellar: :any,                 arm64_sequoia: "3aa87e6f1c42efd344f238a0b5f1ae2f6e7181e0d596681d1df83cc6814bcad8"
    sha256 cellar: :any,                 arm64_sonoma:  "45b2065475667e1e44a677006508f140ef80b7872c122090d28fa29de08ad1cd"
    sha256 cellar: :any,                 sonoma:        "bed4309d315045e39e46893b34650ba498dc02c1a3693ac94e0fa33aac634325"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b297f8c2637957114569dd8e8aff76a2b12732beca5ed1c410ec1aeecf916a2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf1a91326f6ffe43f48d472974c022cb2e5ea5cd7222688725f1ce5bfcde1434"
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
