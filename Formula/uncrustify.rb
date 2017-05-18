class Uncrustify < Formula
  desc "Source code beautifier"
  homepage "https://uncrustify.sourceforge.io/"
  url "https://github.com/uncrustify/uncrustify/archive/uncrustify-0.65.tar.gz"
  sha256 "45e954cd207ee4f6531d72ece27554ef4e0e9f64c912b523bc80ad6a36404110"
  head "https://github.com/uncrustify/uncrustify.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0ed95c1838ebb4da3dbebfceb89db2f159cdaf289ad6871fc71ce4d83af35562" => :sierra
    sha256 "3e2d5dddcbedbb8aa1a7ba063a38c572bea7369ec38a9eedf02433cccd715194" => :el_capitan
    sha256 "89213a509c0ba50028359fc635956aff035cd36e598a3ec75221ce0fb2626be2" => :yosemite
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
    (testpath/"t.c").write <<-EOS.undent
      #include <stdio.h>
      int main(void) {return 0;}
    EOS
    expected = <<-EOS.undent
      #include <stdio.h>
      int main(void) {
      \treturn 0;
      }
    EOS

    system "#{bin}/uncrustify", "-c", "#{doc}/htdocs/default.cfg", "t.c"
    assert_equal expected, File.read("#{testpath}/t.c.uncrustify")
  end
end
