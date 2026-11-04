class SofiaSip < Formula
  desc "SIP User-Agent library"
  homepage "https://sofia-sip.sourceforge.net/"
  url "https://github.com/freeswitch/sofia-sip/archive/refs/tags/v1.13.19.tar.gz"
  sha256 "99389b574dfcff5775b260dd9ef1bdd2bcb5a42e655bd229d477e488e658064f"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "67bdb2c21dbf6434f8750d7814cbc95432822b313516b51ec72a88e3dd00aa46"
    sha256 cellar: :any, arm64_tahoe:       "8b5721163758ead84fa7f2d97b76b7ab16e59b4f7233cf8fe6f3d728025999c4"
    sha256 cellar: :any, arm64_sequoia:     "170a0169e8969daaf6cee1fcb3062724748f93b1fa49238c84bac3e5e5763bf3"
    sha256 cellar: :any, arm64_linux:       "54bb02e51d73c85c8e3e24b6d899e925f8a193ffe0cfbe49cf73d257db8fe43c"
    sha256 cellar: :any, x86_64_linux:      "b6cd9923bed1cfe016cd2feaae0dea81ef54b140bf3e2106ef8484b5e393151e"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build

  depends_on "glib"
  depends_on "openssl@4"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Apply open PR to support OpenSSL 4
  patch do
    url "https://github.com/freeswitch/sofia-sip/commit/affb916edd78d041cfdfa16c72d7744eb734ceca.patch?full_index=1"
    sha256 "1e38bbac3df2cd0a54b0f1239685bb4262872ae03eb1b55d96746d9decc9d3d0"
    type :unofficial
    resolves "https://github.com/freeswitch/sofia-sip/pull/337"
  end

  deny_network_access!

  def install
    system "./bootstrap.sh"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"localinfo"
    system bin/"sip-date"
  end
end
