class SofiaSip < Formula
  desc "SIP User-Agent library"
  homepage "https://sofia-sip.sourceforge.net/"
  url "https://github.com/freeswitch/sofia-sip/archive/refs/tags/v1.13.18.tar.gz"
  sha256 "d2ad4e64753a7c9843b766b8de8081d9c1d7acfaeb53c12b3aed7fdb9235766c"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b1d96d85915ed7a95744337041749a36b841584a499356bc069ce3299332d2da"
    sha256 cellar: :any, arm64_sequoia: "4840834de6b64498db02a4309f9884564cf9341f3ca5d19107c1e00efa096eeb"
    sha256 cellar: :any, arm64_sonoma:  "698a25d99dca0ada63546c8b1fb3be3f9594853c7e9e5b837167a7446518d594"
    sha256 cellar: :any, sonoma:        "a1a08d7d93926c9d060e75696da3bc205f8e827fb1c32682425cf86bde1557bf"
    sha256 cellar: :any, arm64_linux:   "14eb12b0274aef8caa5c1645f8dbbe6585a434c61759389868f2efb6336dd79c"
    sha256 cellar: :any, x86_64_linux:  "4e0073c4f4e0594fcb5c71fec4ae35e3b3e6e59e63e7cbe0176a3a8b1b67cc98"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build

  depends_on "glib"
  depends_on "openssl@3"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "zlib-ng-compat"
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
