class Ssdeep < Formula
  desc "Recursive piecewise hashing tool"
  homepage "https://ssdeep-project.github.io/ssdeep/"
  url "https://github.com/ssdeep-project/ssdeep/releases/download/release-2.14.1/ssdeep-2.14.1.tar.gz"
  sha256 "ff2eabc78106f009b4fb2def2d76fb0ca9e12acf624cbbfad9b3eb390d931313"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f8b44b58f8a6e76ee1061e7bd8d4a6e9ac3a23cca665b88295fdf30c72ce1b66"
    sha256 cellar: :any,                 arm64_monterey: "07961c7cdb77e1bca622785da334e2d80ea789c5619ade29e02f08e5f91249e0"
    sha256 cellar: :any,                 arm64_big_sur:  "ee64c7c583f39962316b19684461489bf1c23ec97d910987430905f8c0b3e26c"
    sha256 cellar: :any,                 ventura:        "880e4fef3feaeb5236d52a45e34b1e2af00977400fe7105e41b3b93d74472ccc"
    sha256 cellar: :any,                 monterey:       "9b57f034329281415c96bebc40f2d30f397ea635a04840044028f8e0bf6bfea2"
    sha256 cellar: :any,                 big_sur:        "07e5950c12637cccbba297963ea3cb11ee93e9e71185ae13d3a3e5a61d3ed2a3"
    sha256 cellar: :any,                 catalina:       "f497e16679d8c9a4e04bc3e2458b5d02f5d2899b1be522df2cfcac88fbd5a672"
    sha256 cellar: :any,                 mojave:         "89e84b13c5e104f7b03a2cf3e9d679a3af57c6432f3c9daa313f9b1caa4cdfb0"
    sha256 cellar: :any,                 high_sierra:    "1c8a9a487676961755daf5688ec478a5925f3a0dfe36faeb7027878600ef2384"
    sha256 cellar: :any,                 sierra:         "84677545f87098d9c5d74719044c56616a8788f1320c9258794807dac2343328"
    sha256 cellar: :any,                 el_capitan:     "c07f5558ed32f7de17f349cbc62e56cf277d3d30c83fa7844bdf41000729dcba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "debece05c49ee73f650afa080d3f0953ac64449c79169525001e871d0888edef"
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    expected = <<~EOS
      ssdeep,1.1--blocksize:hash:hash,filename
      192:1xJsxlk/aMhud9Eqfpm0sfQ+CfQoDfpw3RtU:1xJsPMIdOqBCYLYYB7,"#{include}/fuzzy.h"
    EOS
    assert_equal expected, shell_output("#{bin}/ssdeep #{include}/fuzzy.h")
  end
end
