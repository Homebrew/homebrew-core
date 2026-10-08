class SofiaSip < Formula
  desc "SIP User-Agent library"
  homepage "https://sofia-sip.sourceforge.net/"
  url "https://github.com/freeswitch/sofia-sip/archive/refs/tags/v1.13.18.tar.gz"
  sha256 "d2ad4e64753a7c9843b766b8de8081d9c1d7acfaeb53c12b3aed7fdb9235766c"
  license "LGPL-2.1-or-later"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "fabc44d97a1539149b2e2c7fe20aa6cf6717d7e3f6c4a66d67a4eea506d1e7e4"
    sha256 cellar: :any, arm64_tahoe:       "9bffbe56e6ee6ec3320421daa7a3c28c96da2fe15fed243d8394a19f14263fde"
    sha256 cellar: :any, arm64_sequoia:     "898727a0ec931db7ed9aed51e0c462ac5881e9cf3fbd540f12fe57e75a32de55"
    sha256 cellar: :any, arm64_linux:       "e91f41de3912dad148b345bbe1f6496d57df5383e0434db4b3de083bfe3f7247"
    sha256 cellar: :any, x86_64_linux:      "e5550ff6e6cd1f260155f9b65b7dfa2e1ceed6afaa8154e23dfd23de73f328c1"
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
