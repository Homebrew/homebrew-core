class Screen < Formula
  desc "Terminal multiplexer with VT100/ANSI terminal emulation"
  homepage "https://www.gnu.org/software/screen/"
  url "https://ftpmirror.gnu.org/gnu/screen/screen-5.0.2.tar.gz"
  mirror "https://ftp.gnu.org/gnu/screen/screen-5.0.2.tar.gz"
  sha256 "ca9a2c7e240919bc7ac12124593ae4529bb4eb5f7349d8857829b7e3f0b3b332"
  license "GPL-3.0-or-later"
  head "https://git.savannah.gnu.org/git/screen.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "483ed088b80d3dfeedc0ab9c805f2ef7be4ea06488b64684dbda1b5c1af085f5"
    sha256 arm64_sequoia: "66938dde45a2e0a72eb173935163c7c13d0ac96259acb22feda8b8a8f09caac0"
    sha256 arm64_sonoma:  "05ab2690b011d104de3996b26cbef6ca3fee0e50e72fc532c296b5089d1fe9f8"
    sha256 sonoma:        "9779a73c79dc89c65d9b3c7fcf499362bf7e95773d0b04016726e2cd28f21689"
    sha256 arm64_linux:   "1c2fa985e9ecd3ff54324061a74974d01de3f4346dedd4673c6fef9da8ecb343"
    sha256 x86_64_linux:  "fb7bc859f277b060eefed76eaf63894a524c30215eb35ef286b0ccfc40d57be3"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  uses_from_macos "libxcrypt"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "linux-pam"
  end

  def install
    args = %W[
      --mandir=#{man}
      --infodir=#{info}
      --enable-pam
    ]

    system "./autogen.sh"

    # Exclude unrecognized options
    std_args = std_configure_args.reject { |s| s["--disable-debug"] || s["--disable-dependency-tracking"] }
    system "./configure", *args, *std_args
    system "make", "install"
  end

  test do
    system bin/"screen", "-h"
  end
end
