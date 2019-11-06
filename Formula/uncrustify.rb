class Uncrustify < Formula
  desc "Source code beautifier"
  homepage "https://uncrustify.sourceforge.io/"
  url "https://github.com/uncrustify/uncrustify/archive/uncrustify-0.69.0.tar.gz"
  sha256 "33bd97a07f7c4bd114874f73171aca220bf05c17108f8505a117b97374a347b6"
  head "https://github.com/uncrustify/uncrustify.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6ae285168f69ae667257cc71f0e9e9915c6a3c3e18305f516efa47c3c4b67405" => :catalina
    sha256 "f0d6180d805e5d23e8b246334c1891827dcab715a63b415e52e7e3b22f4c1a96" => :mojave
    sha256 "df8861dad2dc6214dee749c7213e9eae62b7691ca0a616e671e14ea21065061b" => :high_sierra
    sha256 "bc0ccbe0e0dd5834129fcc92cb55335841372a59a31d063062e6031bf36357a5" => :sierra
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
