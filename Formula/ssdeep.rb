class Ssdeep < Formula
  desc "Recursive piecewise hashing tool"
  homepage "https://ssdeep-project.github.io/ssdeep/"
  url "https://github.com/ssdeep-project/ssdeep/releases/download/release-2.14.1/ssdeep-2.14.1.tar.gz"
  sha256 "ff2eabc78106f009b4fb2def2d76fb0ca9e12acf624cbbfad9b3eb390d931313"

  bottle do
    cellar :any
    sha256 "f497e16679d8c9a4e04bc3e2458b5d02f5d2899b1be522df2cfcac88fbd5a672" => :catalina
    sha256 "89e84b13c5e104f7b03a2cf3e9d679a3af57c6432f3c9daa313f9b1caa4cdfb0" => :mojave
    sha256 "1c8a9a487676961755daf5688ec478a5925f3a0dfe36faeb7027878600ef2384" => :high_sierra
    sha256 "84677545f87098d9c5d74719044c56616a8788f1320c9258794807dac2343328" => :sierra
    sha256 "c07f5558ed32f7de17f349cbc62e56cf277d3d30c83fa7844bdf41000729dcba" => :el_capitan
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
