class Uncrustify < Formula
  desc "Source code beautifier"
  homepage "https://uncrustify.sourceforge.io/"
  url "https://github.com/uncrustify/uncrustify/archive/uncrustify-0.68.1.tar.gz"
  sha256 "038d371e7fd10feda8a27f663217eac56fd8d78b0650499e3048d544d836571d"
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
