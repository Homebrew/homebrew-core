class X3270 < Formula
  desc "IBM 3270 terminal emulator for the X Window System and Windows"
  homepage "http://x3270.bgp.nu/"
  url "http://x3270.bgp.nu/download/04.02/suite3270-4.2ga8-src.tgz"
  sha256 "8d25c6977091560a41cc1d411d08371eb3eb446597384b7fd463d33675e2a052"
  license "BSD-3-Clause"

  livecheck do
    url "https://x3270.miraheze.org/wiki/Downloads"
    regex(/href=.*?suite3270[._-]v?(\d+(?:\.\d+)+(?:ga\d+)?)(?:-src)?\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "7e00bf45e5ad099a66f0d934b434b8f41a8be81ecde04c5b6ce32002d65ad707"
    sha256 arm64_monterey: "8a720fabdd6ed1c2485fc2ea79690313af6cbf9ea102fa88fc0f945236cfa8ff"
    sha256 arm64_big_sur:  "abdc9eb96a0aa3082a0972395b1c785dd0bf3ae7f455b18a3f1c67dfe3ebafbd"
    sha256 ventura:        "bc06d0d63e433160b47a0b4a573109057bf312c4ce2d11df18ca3fecb6558e3e"
    sha256 monterey:       "f355bffb0b3419f1b6b7d5d65fb6f0435d5f3dd7a75c539d204a9d69b083bc8f"
    sha256 big_sur:        "5ebb7620dfb21417b3792685f34430ba100128bc95f118227c7f4381fb76c38d"
    sha256 x86_64_linux:   "dfbedded8546c2d24faab13f0b686b765b93e9c9527164aefdfe79329197459e"
  end

  depends_on "readline"

  uses_from_macos "tcl-tk"

  def install
    args = %w[
      --enable-c3270
      --enable-pr3287
      --enable-s3270
      --enable-tcl3270
    ]
    system "./configure", *std_configure_args, *args
    system "make", "install"
    system "make", "install.man"
  end

  test do
    system bin/"c3270", "--version"
  end
end
