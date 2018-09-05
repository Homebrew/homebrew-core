class Uncrustify < Formula
  desc "Source code beautifier"
  homepage "https://uncrustify.sourceforge.io/"
  url "https://github.com/uncrustify/uncrustify/archive/uncrustify-0.67.tar.gz"
  sha256 "0e033e8d1a6fd0b4162ff18d8d0549e475561ebde9d197e3572069cc23c9e70b"
  head "https://github.com/uncrustify/uncrustify.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "22735c84609412aa9ab41ba94f64b73fa5944d4dbf44cee001357785e45ad80d" => :mojave
    sha256 "44e40ac96092d82efd5d7b31f99ce8a8f87df5e400c156ca061a6996780598d1" => :high_sierra
    sha256 "d60af01b3d784640f05b5dd38360186ca7280d386bb02d8526177f69228adea7" => :sierra
    sha256 "285780ad3a0df290ea3a36d166b0c191c9bc5065afbd2294935660c85b741572" => :el_capitan
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
