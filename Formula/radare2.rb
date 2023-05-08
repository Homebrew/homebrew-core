class Radare2 < Formula
  desc "Reverse engineering framework"
  homepage "https://radare.org"
  url "https://github.com/radareorg/radare2/archive/5.8.6.tar.gz"
  sha256 "f6db0bb1a97b1fc51a968ac3131b4b36ad5c1cc15802da03a63c244e24fe7530"
  license "LGPL-3.0-only"
  head "https://github.com/radareorg/radare2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "3b660f9e4bfb219438f592ffa30a6d2dcc22befac05aeffd5478dc8b52757578"
    sha256 arm64_monterey: "f051d613ee8dd27df9b3153d8601bdd6db73557967871790e6e1eeff4735561e"
    sha256 arm64_big_sur:  "1de2e5e6cacb0e2783d3923d7eb87e90b4cb2f564fd87599394017f1c9246772"
    sha256 ventura:        "325f50d955472f1ebb6411e1ac28a3e3f71be34f60e8ebf1fdddf8b94d632741"
    sha256 monterey:       "d018912c92c30d3169e7447e6d582c4c9af12029dfbd9fa8980f81cea2db01a4"
    sha256 big_sur:        "665679390482d77d183e88d3bd5bbc00f2020d3e2697564d3c72f13280232f59"
    sha256 x86_64_linux:   "22167b37dcfdf1b7f64baef23df1628c71697863f54fcae568fa55ac4789b9ec"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "radare2 #{version}", shell_output("#{bin}/r2 -v")
  end
end
