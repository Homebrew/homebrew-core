class Rdfind < Formula
  desc "Find duplicate files based on content (NOT file names)"
  homepage "https://rdfind.pauldreik.se/"
  url "https://rdfind.pauldreik.se/rdfind-1.3.5.tar.gz"
  sha256 "c36e0a1ea35b06ddf1d3d499de4c2e4287984ae47c44a8512d384ecea970c344"

  bottle do
    cellar :any
    sha256 "ca83f17309001b90efbfbf1680d01632def8b5c6827b81f60f1bd64941af37d4" => :mojave
    sha256 "f9cf95ddb7039e4e1a9afcf84e92cb3abdcdcd8e95d9db1862a363b4399f5ea2" => :high_sierra
    sha256 "6e47f48f21af1db473c225fa8bb48682b865fd150fcc4794b0cc5e463cbbd73a" => :sierra
    sha256 "bd9e2a6f1c907f7032df5929b2d5b8ac8394cd3f54c6f0b0d72b753c212b519d" => :el_capitan
  end

  depends_on "nettle"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    mkdir "folder"
    touch "folder/file1"
    touch "folder/file2"
    system "#{bin}/rdfind", "-deleteduplicates", "true", "-ignoreempty", "false", "folder"
    assert_predicate testpath/"folder/file1", :exist?
    refute_predicate testpath/"folder/file2", :exist?
  end
end
