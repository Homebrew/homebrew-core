class Recutils < Formula
  desc "Tools to work with human-editable, plain text data files"
  homepage "https://www.gnu.org/software/recutils/"
  url "https://ftp.gnu.org/gnu/recutils/recutils-1.8.tar.gz"
  mirror "https://ftpmirror.gnu.org/gnu/recutils/recutils-1.8.tar.gz"
  sha256 "df8eae69593fdba53e264cbf4b2307dfb82120c09b6fab23e2dad51a89a5b193"

  bottle do
    cellar :any
    sha256 "a55cbe91cc2c264fe53e5e6425c1f3bb0c090f097f16098fdce766807a38ea6d" => :catalina
    sha256 "1503a69c0ed988355b959c47b2c8a5e5a4f451d41027f5a06cdf5de19f7d171f" => :mojave
    sha256 "c2ca0221b7e7091c11840a000f02b130325a188aeb03b100947562aa8d9ce3ef" => :high_sierra
    sha256 "694cfda88a56f30c66d71080b8a1a4763a17789e0ea54b37c778ba84107f6430" => :sierra
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--datarootdir=#{elisp}"
    system "make", "install"
  end

  test do
    (testpath/"test.csv").write <<~EOS
      a,b,c
      1,2,3
    EOS
    system "#{bin}/csv2rec", "test.csv"

    (testpath/"test.rec").write <<~EOS
      %rec: Book
      %mandatory: Title

      Title: GNU Emacs Manual
    EOS
    system "#{bin}/recsel", "test.rec"
  end
end
