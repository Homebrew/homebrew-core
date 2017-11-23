class Uncrustify < Formula
  desc "Source code beautifier"
  homepage "https://uncrustify.sourceforge.io/"
  url "https://github.com/uncrustify/uncrustify/archive/uncrustify-0.66.1.tar.gz"
  sha256 "0862778fb692ce9859f4ece5e801db72841d8d76d9304e2da52bdd098b05331f"
  head "https://github.com/uncrustify/uncrustify.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "49d8b499a14ce721a4cdf98ac496a7def753342d827e826bc8cd50f334f56e14" => :high_sierra
    sha256 "be5b6c836b51d5a57fb21a9388433b6765a9df434001095b1331e70e0c3ad697" => :sierra
    sha256 "5d6cad2bb86f47fb43e6fa2d4c08b427e622d2e5a4635745e912fa290202d970" => :el_capitan
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
