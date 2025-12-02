class Wmctrl < Formula
  desc "UNIX/Linux command-line tool to interact with an EWMH/NetWM"
  homepage "https://packages.debian.org/sid/wmctrl"
  url "https://deb.debian.org/debian/pool/main/w/wmctrl/wmctrl_1.07.orig.tar.gz"
  sha256 "d78a1efdb62f18674298ad039c5cbdb1edb6e8e149bb3a8e3a01a4750aa3cca9"
  license "GPL-2.0-or-later"
  revision 2

  livecheck do
    url "https://deb.debian.org/debian/pool/main/w/wmctrl/"
    regex(/href=.*?wmctrl[._-]v?(\d+(?:\.\d+)+)\.orig\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "39edb4ef55820d995ac4b636c4215cee31e25c958f59f1d843cc85ee38e690e8"
    sha256 cellar: :any,                 arm64_sequoia:  "76d0afbd8d8a925bf3d2137457f49f03f9550733358079820150adc2976010c3"
    sha256 cellar: :any,                 arm64_sonoma:   "6a1a692f4cb4c2246cb4e1f3e53dfe9e6c56486dd706a7910704e9a09def7cb9"
    sha256 cellar: :any,                 arm64_ventura:  "388c8eb49eeca6f9ced7eb9d3c7418e7b2f6a5f4cc4a77263e4ddb92ae135b8b"
    sha256 cellar: :any,                 arm64_monterey: "fb8c3a7dcd11a32b075ba4181f5825bfd9b55a8ee1453f4ad8454c7dd56cf6cf"
    sha256 cellar: :any,                 arm64_big_sur:  "83b97edb3df52830587f710abc9bbfc53c0a7b3567a18f94c2161be6b988980a"
    sha256 cellar: :any,                 sonoma:         "2deab4d4326107696a376b85a27c9417b59727513f99b9b5b336f72fb2ac2dcf"
    sha256 cellar: :any,                 ventura:        "f4b9bdf79af82a76f5cec5db96d01bb48d2c321d96c7b09e8794a1937243ba56"
    sha256 cellar: :any,                 monterey:       "a5d76fe085cc3ca15ab736376b8250c82fde97e364117bbc7f7050e599dda640"
    sha256 cellar: :any,                 big_sur:        "90c60692d669660d4d8037d2c6fa94cc13f14b6bb85e6909d0707f30644edde5"
    sha256 cellar: :any,                 catalina:       "d585a38070e3343da1be66819f7d3f840140acee8dde1d3912542d682466ee48"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "c2f47127d88a26b2522b3948371f2152de9e0ca35bb7a4a33d4feb2a2424ea6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f35104a632334a639f0c7d233baea5a9177a2d43fe78cd563870c97b394d78bc"
  end

  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "libice"
  depends_on "libsm"
  depends_on "libx11"
  depends_on "libxmu"

  on_macos do
    depends_on "gettext"
  end

  # Fix for 64-bit arch. See:
  # https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=362068
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/wmctrl/1.07.patch"
    sha256 "8599f75e07cc45ed45384481117b0e0fa6932d1fce1cf2932bf7a7cf884979ee"
  end

  def install
    system "./configure", "--mandir=#{man}", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"wmctrl", "--version"
  end
end
