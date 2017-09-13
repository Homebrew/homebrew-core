class Ssdeep < Formula
  desc "Recursive piecewise hashing tool"
  homepage "https://ssdeep-project.github.io/ssdeep/"
  url "https://github.com/ssdeep-project/ssdeep/releases/download/release-2.14/ssdeep-2.14.tar.gz"
  sha256 "3aad00b51adf8f0086b37198e50dc779d2313b7d9df09a96bce73c5376dcdd36"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    expected = <<-EOS.undent
      ssdeep,1.1--blocksize:hash:hash,filename
      192:1xJsxlk/aMhud9Eqfpm0sfQ+CfQoDfpw3RtU:1xJsPMIdOqBCYLYYB7,"#{include}/fuzzy.h"
    EOS
    assert_equal expected, shell_output("#{bin}/ssdeep #{include}/fuzzy.h")
  end
end
