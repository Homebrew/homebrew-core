class Screen < Formula
  desc "Terminal multiplexer with VT100/ANSI terminal emulation"
  homepage "https://www.gnu.org/software/screen/"
  url "https://ftpmirror.gnu.org/gnu/screen/screen-5.0.1.tar.gz"
  mirror "https://ftp.gnu.org/gnu/screen/screen-5.0.1.tar.gz"
  sha256 "2dae36f4db379ffcd14b691596ba6ec18ac3a9e22bc47ac239789ab58409869d"
  license "GPL-3.0-or-later"
  head "https://git.savannah.gnu.org/git/screen.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "7257e441151c134ddfaa36a4ebdddf11256d8eeca39f89a3f573970e95857dda"
    sha256 arm64_sequoia: "9430cdd222c4561bdfeee141fa6e334dc0a10d5fe7c4489ec287c9d44cfc6b6e"
    sha256 arm64_sonoma:  "2e75496e4bed33bafec7fbc33ac0b9ecfedd5afb0c283dbca100dfc5efc57f43"
    sha256 arm64_ventura: "cfe661d88372ca2f8df595ed7c46a859bf4871c435c3a499b4e2cd4754732dfa"
    sha256 sonoma:        "5306e70837deb34094054f1264e76455b7484718ee4536b0343351a852a895d1"
    sha256 ventura:       "d5c01fece1e58f947c7839f9ae8a0d6482925c3e36202ef66fb90d5d039287c1"
    sha256 arm64_linux:   "a2eaa7bce2a69592916bb6a278142910411a81ed2f091a38fcb6425b6b7ff765"
    sha256 x86_64_linux:  "a2319a7727c30f53ed3ef157ad24ee761fc542e65ef1ed8c985ed6abcbf4a29c"
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
