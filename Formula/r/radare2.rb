class Radare2 < Formula
  desc "Reverse engineering framework"
  homepage "https://radare.org"
  url "https://github.com/radareorg/radare2/archive/refs/tags/5.9.4.tar.gz"
  sha256 "4b194a73ce8dfe12c0b8c70cf6af449260119588ceacc205ac95570bbf17cdd3"
  license "LGPL-3.0-only"
  head "https://github.com/radareorg/radare2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "bca17b5e0bda234525315cfc1864ac91aff981573fea343ff487192db49f76bb"
    sha256 arm64_ventura:  "88d901ad50b60f6d05e1d63762757848e3ea3b8f7be23ba718ce771f9f287448"
    sha256 arm64_monterey: "1962f702cca5f81a601f9542e11a2b293d904723d73a04d0509d1d39b331e94c"
    sha256 sonoma:         "b48c10c4382b79427c7aef420b549dac9219868af7b625b001c65c9391946cc0"
    sha256 ventura:        "7ccd44be7f381dc92c39610e2de8cf8be63c724acb3210593eeb671025a462f2"
    sha256 monterey:       "86eae99d268bc12ffb696cf9d7a37232d04932250f76bb7193c4b4ba62947ad6"
    sha256 x86_64_linux:   "9fcf8c636062c1cc384215367378842f2742543ea4d2db87bde44516a64f78e3"
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
