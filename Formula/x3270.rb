class X3270 < Formula
  desc "IBM 3270 terminal emulator for the X Window System and Windows"
  homepage "http://x3270.bgp.nu/"
  url "http://x3270.bgp.nu/download/04.02/suite3270-4.2ga6-src.tgz"
  sha256 "093089bd672cd7424652cebdd4b77105c0ca686b12b376d5810d1ba07ca411c0"
  license "BSD-3-Clause"

  livecheck do
    url "https://x3270.miraheze.org/wiki/Downloads"
    regex(/href=.*?suite3270[._-]v?(\d+(?:\.\d+)+(?:ga\d+)?)(?:-src)?\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "de5c59e82957ce1b819a2cbf93d6d217937ec1f6555a760ea45b89221125b733"
    sha256 arm64_monterey: "604766c1bf6c05c887c47aa3b0cbe4f1201698afe715848df1b4d948ec50e7f5"
    sha256 arm64_big_sur:  "6bf49cb2393e6baf25537a828a18372a64299f755eac0d70a0b1cbf2f4246d45"
    sha256 ventura:        "ac34311ec3813bb256187a9ad4fae8fd46702c87b3ebcf755d7973ea09bcf4a8"
    sha256 monterey:       "c4142e2a3aa1c7e4b0b8eb3fef72ccb37f504a896c06bc261a1b5242c7a8e3d3"
    sha256 big_sur:        "77581025d5a96f40786e92202a1505dee9644fe99340e9a075e842b393ed6bb6"
    sha256 catalina:       "7a8fcecb84520174289081b6c64477465ef8eb346526b3a5d20cc6188f8587d7"
    sha256 x86_64_linux:   "e928a308007f88e7d4311ce901f8e1e7d2ec375eaa9fcb86a56bffacf0e2f34e"
  end

  depends_on "readline"

  uses_from_macos "tcl-tk"

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-c3270
      --enable-pr3287
      --enable-s3270
      --enable-tcl3270
    ]
    system "./configure", *args
    system "make", "install"
    system "make", "install.man"
  end

  test do
    system bin/"c3270", "--version"
  end
end
