class Uncrustify < Formula
  desc "Source code beautifier"
  homepage "http://uncrustify.sourceforge.net/"
  url "https://github.com/uncrustify/uncrustify/archive/uncrustify-0.64.tar.gz"
  sha256 "2a8cb3ab82ca53202d50fc2c2cec0edd11caa584def58d356c1c759b57db0b32"
  head "https://github.com/uncrustify/uncrustify.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8889c95952f0106f0f602415617ccbe85c20aa932b8c8429849e958458118c9a" => :sierra
    sha256 "387c422d75c6f1ca680cc4a0b8541dda9aeb40cd7b3fcf685efddbf1f29ea2d6" => :el_capitan
    sha256 "9e2c5d484dc6cc7a9eaa26b3b26ebeafaa9974144e43fcb6fedcae4196f0a654" => :yosemite
    sha256 "7bbc100632b13c81d2ec3ab897629f49effbb5dc76f991c4abde65566742b868" => :mavericks
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
