class Radare2 < Formula
  desc "Reverse engineering framework"
  homepage "https://radare.org"
  url "https://github.com/radareorg/radare2/archive/5.6.6.tar.gz"
  sha256 "ef934b786cce10bf16e9e0b0fd3b3d338af33a83ae83bbd50101facc39549961"
  license "LGPL-3.0-only"
  head "https://github.com/radareorg/radare2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_monterey: "0c8fdf19707bef9879d9e440e2ec43243f78603d2d878fe37c6b87729e440f35"
    sha256 arm64_big_sur:  "0b60ba58f6defcc8f69faa3f0686a97b00248965c6676be09ed1e59209afa2a4"
    sha256 monterey:       "97c819c34678390752ac39909b20ffc02e628554ff1e228c032b3483a2b9ec6f"
    sha256 big_sur:        "fee5fffd2c51c48381035f571a3e264b2cb4f121b30436036f433ba51509a2e8"
    sha256 catalina:       "57472f3d96ff938be5713e6cb58c948b2a03b9254ffc88620722008853fa0117"
    sha256 x86_64_linux:   "fe4072a2d7e484ab4e224acd81a674175d37aef208a4078c19ed7c3d713c133a"
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
