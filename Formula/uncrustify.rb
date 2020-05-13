class Uncrustify < Formula
  desc "Source code beautifier"
  homepage "https://uncrustify.sourceforge.io/"
  url "https://github.com/uncrustify/uncrustify/archive/uncrustify-0.71.0.tar.gz"
  sha256 "403a0f34463c0d6b0fbf230d8a03b7af9f493faa235208417793350db062003c"
  head "https://github.com/uncrustify/uncrustify.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6e67d8d13b9495efd0e59e068a2e2ec2a4b637d60467d84293a001ef6a3ef823" => :catalina
    sha256 "53d2b599a9f90fe3b7b4535907a98afbe055099bbc79b56bb03421146ff3c6fc" => :mojave
    sha256 "b034c345925922b9e52b7c83107f8accfd1c1fa1d74ebc9dd269b5296ae13e37" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
    doc.install (buildpath/"documentation").children
  end

  test do
    (testpath/"t.c").write <<~EOS
      #include <stdio.h>
      int main(void) {return 0;}
    EOS
    expected = <<~EOS
      #include <stdio.h>
      int main(void) {
      \treturn 0;
      }
    EOS

    system "#{bin}/uncrustify", "-c", "#{doc}/htdocs/default.cfg", "t.c"
    assert_equal expected, File.read("#{testpath}/t.c.uncrustify")
  end
end
