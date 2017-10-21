class Ssdeep < Formula
  desc "Recursive piecewise hashing tool"
  homepage "https://ssdeep-project.github.io/ssdeep/"
  url "https://github.com/ssdeep-project/ssdeep/releases/download/release-2.14/ssdeep-2.14.tar.gz"
  sha256 "3aad00b51adf8f0086b37198e50dc779d2313b7d9df09a96bce73c5376dcdd36"

  bottle do
    cellar :any
    sha256 "920b4dba1a5edebc72278a7b77ca99c0c2d01cde21854d26a730745751b60050" => :high_sierra
    sha256 "e1e51327a493f62a0ee23970e052e05037207b733d32f42280084c2d46b9d03b" => :sierra
    sha256 "6e6d611d9391ce64ae983e2b1622c69ded52600f6e1791034e1d796d868e1123" => :el_capitan
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
