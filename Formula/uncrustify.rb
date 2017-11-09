class Uncrustify < Formula
  desc "Source code beautifier"
  homepage "https://uncrustify.sourceforge.io/"
  url "https://github.com/uncrustify/uncrustify/archive/uncrustify-0.66.tar.gz"
  sha256 "ae5ca91419be71291d4a5be15439c11bdfc0adb350cbc0688b9a51085489a7f9"
  head "https://github.com/uncrustify/uncrustify.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "da799d5258680c34ca9e8b9840364c4c9e9ee0992cf27ca428294b9a7446c25c" => :high_sierra
    sha256 "7aa15a6b8463dbad2c015cacf286d3629a411814259e815f11bc71e301eab66b" => :sierra
    sha256 "f3ebd4ba2c354d2d6f739524ef2a4016063f318aa0eef6bd39e1c2490076fda5" => :el_capitan
    sha256 "5ebbc8e9fde8672c6f7875b63c494378fef7c3fb84d518a1ff0fb32ea18a3738" => :yosemite
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
