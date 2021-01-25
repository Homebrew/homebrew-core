class Rdfind < Formula
  desc "Find duplicate files based on content (NOT file names)"
  homepage "https://rdfind.pauldreik.se/"
  url "https://rdfind.pauldreik.se/rdfind-1.4.1.tar.gz"
  sha256 "30c613ec26eba48b188d2520cfbe64244f3b1a541e60909ce9ed2efb381f5e8c"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?rdfind[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "ade2aaffee4c52e143fdcd0a22fae933e60e4c3d5057e4bc74a9aaffaf3c2146" => :big_sur
    sha256 "354f66f386e4ea54db4efcdeca59c897fa985ec2567ec7677eb62e1d975bbf6c" => :arm64_big_sur
    sha256 "e890406a4cbbd8d026a4c583644efa537433ac71c095a1e582b0454d85a87d00" => :catalina
    sha256 "489e104d2c5e5d939439f5b100cd97e19ed070181d355b49fbd1ad2b3320d789" => :mojave
    sha256 "2ce91e3b8a129c0fadb57fba46074e74e0d896287c23eb1844cd99e5eef093b1" => :high_sierra
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
    (testpath/"folder/file1").write("foo")
    (testpath/"folder/file2").write("bar")
    (testpath/"folder/file3").write("foo")
    system "#{bin}/rdfind", "-deleteduplicates", "true", "folder"
    assert_predicate testpath/"folder/file1", :exist?
    assert_predicate testpath/"folder/file2", :exist?
    refute_predicate testpath/"folder/file3", :exist?
  end
end
