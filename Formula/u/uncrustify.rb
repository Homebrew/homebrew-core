class Uncrustify < Formula
  desc "Source code beautifier"
  homepage "https://uncrustify.sourceforge.net/"
  url "https://github.com/uncrustify/uncrustify/archive/refs/tags/uncrustify-0.81.0.tar.gz"
  sha256 "484623dc16b92206adc6ac0770077c6c67c6e441102148c2a121a19549330ff9"
  license "GPL-2.0-or-later"
  head "https://github.com/uncrustify/uncrustify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95185b021122589ff6c0c457ca16433fa0dad4199eda25ac9d27dd3766ad45ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b637552b2ae8ce6b96724cc43c963787b96d4ac10fecc801a9f19cd32b8d4a8f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "49ca479826a62c4ee74245651b6c2516204b0ad7799fcb5df55cc2784e6c1bd4"
    sha256 cellar: :any_skip_relocation, sonoma:        "b10c110b8a8d4e68cafc48388a43c912dbc24418ef696327f4d51f2015abe81a"
    sha256 cellar: :any_skip_relocation, ventura:       "264d193e45520357f4d7f5b78f5678a764830c32e2a610841411d81f520aab35"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "04b1104857cacbf2c9a3008a22166c79b3979fd2bf63febae974ec662a0fbc42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0cb6aeb4dc069d9b46f27bbd6ecedc413fb7d617c22f88db6c562f106ee05cd8"
  end

  depends_on "cmake" => :build
  uses_from_macos "python" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    doc.install (buildpath/"documentation").children
  end

  test do
    (testpath/"t.c").write <<~C
      #include <stdio.h>
      int main(void) {return 0;}
    C

    expected = <<~C
      #include <stdio.h>
      int main(void) {
      \treturn 0;
      }
    C

    system bin/"uncrustify", "-c", doc/"htdocs/default.cfg", "t.c"
    assert_equal expected, (testpath/"t.c.uncrustify").read
  end
end
