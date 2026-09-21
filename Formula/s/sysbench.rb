class Sysbench < Formula
  desc "System performance benchmark tool"
  homepage "https://github.com/akopytov/sysbench"
  url "https://github.com/akopytov/sysbench/archive/refs/tags/1.0.20.tar.gz"
  sha256 "e8ee79b1f399b2d167e6a90de52ccc90e52408f7ade1b9b7135727efe181347f"
  license "GPL-2.0-or-later"
  revision 7
  head "https://github.com/akopytov/sysbench.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "18b8617b1b751de9708096f2d5fc4dbffc2b17ecb19a270101156f6ab287eca2"
    sha256 cellar: :any, arm64_tahoe:       "15552662a25c619ba6c94c583c6dde95889f0c77265657d09b4e01bb824085f9"
    sha256 cellar: :any, arm64_sequoia:     "010ae049456b9bafd3eb3ce43553e7186e3e680616ea27ee0964cef0e4f40e2f"
    sha256 cellar: :any, arm64_linux:       "69591d450616f00645bae4f68515312fbfbad4f36df3d534d8490fff181b0b65"
    sha256 cellar: :any, x86_64_linux:      "e60860ff76b07b74318cf63a78064d6715cb94ea7e0b805b0401b0f8b3103d89"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "libpq"
  depends_on "luajit"
  depends_on "mariadb-connector-c"

  uses_from_macos "vim" # needed for xxd

  def install
    # C23 rejects the K&R-style function definitions in the bundled crc32.c
    ENV.append_to_cflags "-std=gnu17"
    system "./autogen.sh"
    system "./configure", "--with-mysql", "--with-pgsql", "--with-system-luajit", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"sysbench", "--test=cpu", "--cpu-max-prime=1", "run"
  end
end
