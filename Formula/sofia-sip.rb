class SofiaSip < Formula
  desc "SIP User-Agent library"
  homepage "https://sofia-sip.sourceforge.io/"
  url "https://github.com/freeswitch/sofia-sip/archive/v1.13.14.tar.gz"
  sha256 "a517e31c6a406af3d7ec8cb0154e46ad12fbcb54dadfc3deada5d97bdbd9cc5a"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "bfb64a936a3aeaa45e62ebbec38ef5c80367a90b35c132937cfffe7915e88634"
    sha256 cellar: :any,                 arm64_monterey: "a813e90a4350f194fadb9b391166fc4f228365164aeb023f82e49351b2af8db7"
    sha256 cellar: :any,                 arm64_big_sur:  "d1e1035d5208ec5ed8524fc0fa833f24d5779ded1ad8bf460c98e189d3293e76"
    sha256 cellar: :any,                 ventura:        "e3eba59e3f47f5a1eec8fc2742b2ce283a2342c931dd2021cf72371a026c4a0c"
    sha256 cellar: :any,                 monterey:       "65c5af6c9db07ea047a68655649384cecf400e312048738364698d3b94a46102"
    sha256 cellar: :any,                 big_sur:        "394da7b648bd351e1e6c88d222f44b9912268a0fe20dbfaf277b486bf058b51d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b2b254d850f0c82836fff43ab69e8dd01dc3306753e200b9d08faec38f65532"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "openssl@1.1"

  def install
    system "./bootstrap.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/localinfo"
    system "#{bin}/sip-date"
  end
end
