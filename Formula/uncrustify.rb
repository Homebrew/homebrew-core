class Uncrustify < Formula
  desc "Source code beautifier"
  homepage "https://uncrustify.sourceforge.io/"
  url "https://github.com/uncrustify/uncrustify/archive/uncrustify-0.66.1.tar.gz"
  sha256 "0862778fb692ce9859f4ece5e801db72841d8d76d9304e2da52bdd098b05331f"
  head "https://github.com/uncrustify/uncrustify.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e902a2207489b25f23908161c8695b68a05d30c697621f2233fc03e48ba3960f" => :high_sierra
    sha256 "d95da710ae416bfacd68d923455d600132490e688b71d0d99963a082cacfdc66" => :sierra
    sha256 "a736e794ffde1ad84cdc8d8f259496af608e42d66ef6bb9b2b348f17e34e66f8" => :el_capitan
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
