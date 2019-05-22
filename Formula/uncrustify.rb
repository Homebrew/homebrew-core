class Uncrustify < Formula
  desc "Source code beautifier"
  homepage "https://uncrustify.sourceforge.io/"
  url "https://github.com/uncrustify/uncrustify/archive/uncrustify-0.69.0.tar.gz"
  sha256 "33bd97a07f7c4bd114874f73171aca220bf05c17108f8505a117b97374a347b6"
  head "https://github.com/uncrustify/uncrustify.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fe33a43615dfdb24d4d11cca7e4ba9c8b85dcd679dd52dd074e2d3346dbc90e7" => :mojave
    sha256 "70f9b02d6000712c79d2f9236ea5abe9a46756b7b892ee3fd6cb8d8c7e6cc045" => :high_sierra
    sha256 "3160bd989bf75c02632ba127547cfac7f93a3ea4e9a415ed8e898615f85f160c" => :sierra
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
