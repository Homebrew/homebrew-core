class Uncrustify < Formula
  desc "Source code beautifier"
  homepage "https://uncrustify.sourceforge.net/"
  url "https://github.com/uncrustify/uncrustify/archive/refs/tags/uncrustify-0.79.0.tar.gz"
  sha256 "e7afaeabf636b7f0ce4e3e9747b95f7bd939613a8db49579755dddf44fedca5f"
  license "GPL-2.0-or-later"
  head "https://github.com/uncrustify/uncrustify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "bd6c01e2ea7eb4cb327cf01fe9dd248d60f37846545927453c333cda5554f67d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bffdfbf17b6eb0c781fa7141fb02e92b0a601cd4ceac35cc356d9cdd26dc2636"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4c16c1efe048bee421a9d20ca62ddcb1a133f6ae48d5461e714607f6b9280a2d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b24f7b0cb08ca53782bc8882cac2272c8eb9609d2079c7d8ecc01babae05583f"
    sha256 cellar: :any_skip_relocation, sonoma:         "b3d5e126a00e64024c28b2ebe1f05a1b7e38da32912a0fa0834c268ea6edfbb3"
    sha256 cellar: :any_skip_relocation, ventura:        "0203cc842a538476e70a96c0f566c604e6ff0aed05fc6f09e7f3fc1d3109b760"
    sha256 cellar: :any_skip_relocation, monterey:       "4018e748acd7ed470ab1090d85307f63d5638b18fbfdf9ba3eff822c303b0c59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3a5450c682fb4a635b43c6b6479ef572029cc7933cc3b2dbb08c8f3a51c6c45"
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

    system bin/"uncrustify", "-c", doc/"htdocs/default.cfg", "t.c"
    assert_equal expected, (testpath/"t.c.uncrustify").read
  end
end
