class Uncrustify < Formula
  desc "Source code beautifier"
  homepage "https://uncrustify.sourceforge.io/"
  url "https://github.com/uncrustify/uncrustify/archive/uncrustify-0.70.1.tar.gz"
  sha256 "ad0a7b1f68aa3527d1b89d177d192385fe41b830d46167bde3c3b578e9b0ed06"
  head "https://github.com/uncrustify/uncrustify.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "469d1f4300d8dbb2948c25e4e3f392bdde60e155826d4e600883cc2295b0416b" => :catalina
    sha256 "9f71fed2975c8806e5777258cae7a3abe78161aa4249c049267dd56e3dda5e55" => :mojave
    sha256 "9156b1c02f407548ca7333b53621f4a498488c47338784f307df30e573fe7327" => :high_sierra
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
