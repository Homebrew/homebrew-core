class Wmctrl < Formula
  desc "UNIX/Linux command-line tool to interact with an EWMH/NetWM"
  homepage "https://sites.google.com/site/tstyblo/wmctrl"
  url "https://sites.google.com/site/tstyblo/wmctrl/wmctrl-1.07.tar.gz"
  sha256 "d78a1efdb62f18674298ad039c5cbdb1edb6e8e149bb3a8e3a01a4750aa3cca9"
  license "GPL-2.0-or-later"
  revision 2

  livecheck do
    url :homepage
    regex(/href=.*?wmctrl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "fb8c3a7dcd11a32b075ba4181f5825bfd9b55a8ee1453f4ad8454c7dd56cf6cf"
    sha256 cellar: :any,                 arm64_big_sur:  "83b97edb3df52830587f710abc9bbfc53c0a7b3567a18f94c2161be6b988980a"
    sha256 cellar: :any,                 monterey:       "a5d76fe085cc3ca15ab736376b8250c82fde97e364117bbc7f7050e599dda640"
    sha256 cellar: :any,                 big_sur:        "90c60692d669660d4d8037d2c6fa94cc13f14b6bb85e6909d0707f30644edde5"
    sha256 cellar: :any,                 catalina:       "d585a38070e3343da1be66819f7d3f840140acee8dde1d3912542d682466ee48"
    sha256 cellar: :any,                 mojave:         "49f4d10d0e8d8b4cfa2e5ba4240f5c623f01b66d4e466eace255c1496c627da5"
    sha256 cellar: :any,                 high_sierra:    "10200373a514341920fd453d769c07040eae2ba01a691c418d10b6a1d44ec70b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f35104a632334a639f0c7d233baea5a9177a2d43fe78cd563870c97b394d78bc"
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "libice"
  depends_on "libsm"
  depends_on "libx11"
  depends_on "libxmu"

  # Fix for 64-bit arch. See:
  # https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=362068
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/wmctrl/1.07.patch"
    sha256 "8599f75e07cc45ed45384481117b0e0fa6932d1fce1cf2932bf7a7cf884979ee"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/wmctrl", "--version"
  end
end
