class SofiaSip < Formula
  desc "SIP User-Agent library"
  homepage "https://sofia-sip.sourceforge.net/"
  url "https://github.com/freeswitch/sofia-sip/archive/refs/tags/v1.13.17.tar.gz"
  sha256 "daca3d961b6aa2974ad5d3be69ed011726c3e4d511b2a0d4cb6d878821a2de7a"
  license "LGPL-2.1-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "6ba4ea78c36c9ed77a42af041593b55c640166be67807d990e92790da85d2873"
    sha256 cellar: :any,                 arm64_sequoia: "3c841df2ed595da217f0dc91ed1c9cc15b946b4855a1387fe1ce1169197afaff"
    sha256 cellar: :any,                 arm64_sonoma:  "c53e73fd2cc77275982b7f56d13b3adf31d41c5dc434c2b1f1d53fd134db04e7"
    sha256 cellar: :any,                 sonoma:        "168570524047f906e3cd945efaf21653f272d5928070dcfd842c126fecc50f6f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f6c88d7708adaab7ed601daed19702899de571b252a8e0a7a5946523a1555c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11f9c56b4460dc17cb0cc252281b2aa6814c1a37f2de26ef51f045c974428a25"
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
