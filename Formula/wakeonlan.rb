class Wakeonlan < Formula
  desc "Sends magic packets to wake up network-devices"
  homepage "https://github.com/jpoliv/wakeonlan"
  url "https://github.com/jpoliv/wakeonlan/archive/wakeonlan-0.41.tar.gz"
  sha256 "1d8c3cd106f515167e49134abb8209af891ca152a00ee94a8c5137f654e079bc"
  license "Artistic-1.0-Perl"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "070077705631ce2eb31d05d055297b181a880ed9e03563ef7e1d50c52ded85d9"
    sha256 cellar: :any_skip_relocation, big_sur:       "d4c56be5fe1924a04a6c8fcb3f36f42f68f340b5f987536a0e4fc812362818d0"
    sha256 cellar: :any_skip_relocation, catalina:      "017f70ad18520de448fa1e31d0e53d4b52ad548518da6923808b85d850bf3ee4"
    sha256 cellar: :any_skip_relocation, mojave:        "5fc2054a08a4ce9d08b5d004917acb1b57b198611f693503fca252550778a90b"
    sha256 cellar: :any_skip_relocation, high_sierra:   "876e4fd4919523eb2db07159a7c7d82fa30bec74972f0ef69c55588831db8a4d"
    sha256 cellar: :any_skip_relocation, sierra:        "2cb19ca9617f87fc2c14536434f17b44174336a739fed3ad83404ccfb412ee31"
    sha256 cellar: :any_skip_relocation, el_capitan:    "7da7f512ae921016be21fa3899d4f01841e3da5bc96570fcd85b530e4e720c06"
    sha256 cellar: :any_skip_relocation, yosemite:      "78a5d905b250ddb09cc3fa4296f2ffc8c925788a7d8e5d05e96f5581e81a7e9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4a712953c99f9fbaa58324ec19b50d327c75eacf3ecc2fb9c7ee8a6f6334c5a"
    sha256 cellar: :any_skip_relocation, all:           "fab33ab022dca1acde2b301a811991a04d7793504bd2504ae22c6f87ae92087e"
  end

  uses_from_macos "perl"

  def install
    system "perl", "Makefile.PL"
    system "make"
    bin.install "blib/script/wakeonlan"
    man1.install "blib/man1/wakeonlan.1"
  end

  test do
    system "#{bin}/wakeonlan", "--version"
  end
end
