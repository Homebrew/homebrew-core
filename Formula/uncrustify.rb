class Uncrustify < Formula
  desc "Source code beautifier"
  homepage "https://uncrustify.sourceforge.io/"
  url "https://github.com/uncrustify/uncrustify/archive/uncrustify-0.71.0.tar.gz"
  sha256 "403a0f34463c0d6b0fbf230d8a03b7af9f493faa235208417793350db062003c"
  license "GPL-2.0"
  head "https://github.com/uncrustify/uncrustify.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8071c9d74d2ed2fdd69c8b9f665dbbcf364cb961796d014adcee6ad71be37e67" => :catalina
    sha256 "9ede4664a01943bc10c07e643a2c4af2de8c1d91a534a954c78d92780f235b35" => :mojave
    sha256 "60ffa3330811d4499f928eb7124d6981c1afb24ec0c86a4325d2804c65189828" => :high_sierra
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
