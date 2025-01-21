class Screen < Formula
  desc "Terminal multiplexer with VT100/ANSI terminal emulation"
  homepage "https://www.gnu.org/software/screen/"
  url "https://ftp.gnu.org/gnu/screen/screen-5.0.0.tar.gz"
  mirror "https://ftpmirror.gnu.org/screen/screen-5.0.0.tar.gz"
  sha256 "f04a39d00a0e5c7c86a55338808903082ad5df4d73df1a2fd3425976aed94971"
  license "GPL-3.0-or-later"
  head "https://git.savannah.gnu.org/git/screen.git", branch: "master"

  bottle do
    sha256 arm64_sequoia:  "a3bc5d7cdcceeccd9b72dbe6a91be12d2fa1198afbd8c412c1b64248468924f6"
    sha256 arm64_sonoma:   "799fb23e0d4fa3080d3c0d1fa7313232e187a08339ebc120dbe774e4d7283fb8"
    sha256 arm64_ventura:  "ae03adaaab11ea47b40168ca31316b9910027864836d9c11780f910b8d003152"
    sha256 arm64_monterey: "bb3591af4348104c63bfb58afab5b22f2b6df98e36963c9c08be6ca1e01b8a27"
    sha256 sonoma:         "adc56240e8ecaf23de62dfe67017b64eeda8538554c29ba5b4411f5fd8ec0e64"
    sha256 ventura:        "5caa5be6136e3844d66ac11b609caef27f59553e4f596998bc5bf4817b830337"
    sha256 monterey:       "8c8d9322b5d5230f3a245668c1ff8117b0128077ae79adfe8a657cd70cc2434d"
    sha256 x86_64_linux:   "cf41a2d3353e0653d07a095b56d554a55fc72ac6c74fc4a34bc056f3d95463f5"
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
