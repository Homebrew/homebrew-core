class Uncrustify < Formula
  desc "Source code beautifier"
  homepage "https://uncrustify.sourceforge.io/"
  url "https://github.com/uncrustify/uncrustify/archive/uncrustify-0.68.tar.gz"
  sha256 "28a0f48696c23e844979e6b7cd6398b8c74d359f0926fc649512fc0e03cbae9f"
  head "https://github.com/uncrustify/uncrustify.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e38bc9c71ad6fce189ba22672fe419e16842303c4dbcb175c1a3ddda88abcd84" => :mojave
    sha256 "4a1c4ee728c6eac8483c22b92ae46da4ed714e13b551e9e8d3df72cfebcb2930" => :high_sierra
    sha256 "b54265611c738e58e225705e09f5124733b9806d3f62eaa5784e289d635c62f8" => :sierra
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
