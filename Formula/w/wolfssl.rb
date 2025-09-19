class Wolfssl < Formula
  desc "Embedded SSL Library written in C"
  homepage "https://www.wolfssl.com"
  # Git checkout automatically enables extra hardening flags
  # Ref: https://github.com/wolfSSL/wolfssl/blob/master/m4/ax_harden_compiler_flags.m4#L71
  url "https://github.com/wolfSSL/wolfssl.git",
      tag:      "v5.8.2-stable",
      revision: "decea12e223869c8f8f3ab5a53dc90b69f436eb2"
  license "GPL-3.0-or-later"
  head "https://github.com/wolfSSL/wolfssl.git", branch: "master"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+)[._-]stable/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6bcacaa9f6c73e3cf3186dffe29276a66039f99c73d69d5df8225a0dbe3410ad"
    sha256 cellar: :any,                 arm64_sequoia: "44c8763615d5c0b67f49b16e0d7789329e84fd573277a9dc0c56bc6068917ed8"
    sha256 cellar: :any,                 arm64_sonoma:  "9e0676d21cb03b5fa391c1764ca008cd12f8190b217d94e7cf27f8ae68699210"
    sha256 cellar: :any,                 arm64_ventura: "c9e58662829671584d8cfc2c047bcabacd30ef33cdef940c607adcafae651421"
    sha256 cellar: :any,                 sonoma:        "45c38bf6c1fca774e0efe0c1789cd74a0a1259d0f199bf3c5f9bd78ba23147a1"
    sha256 cellar: :any,                 ventura:       "b1b087f768878b139a39e161b202270b21a7175767a4e65434b62d5c068662da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9ede4cdae63c6acea1f3a02ac00e640b5cde98a40f466a975d86e0323d8d685"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f83fa4dbec5dab24d91a3e1113a3c6a582cf9cf82249bd4d712d1629389ec264"
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
