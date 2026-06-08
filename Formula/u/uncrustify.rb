class Uncrustify < Formula
  desc "Source code beautifier"
  homepage "https://uncrustify.sourceforge.net/"
  url "https://github.com/uncrustify/uncrustify/archive/refs/tags/uncrustify-0.83.0.tar.gz"
  sha256 "1d4d3ab3a991c66eb24cb0a3e690573b4882fd98bc6ec64a01c283998c20dc87"
  license "GPL-2.0-or-later"
  head "https://github.com/uncrustify/uncrustify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "134d4f23548f37e9bcd1473e631356aa661c8932f5d0a7e921651b9c2a845476"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e7415d06eeb5fb68674acf1fc13d75bb48c91786067bc1173bf8bf9b3d62111"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d7aa4f2db4a166e7ab54f519ca24d77fd03d6a0b1d7f9a6766e71d9898b8faf"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca8cf7e06ca7c3c4dce17357161c6bfde9916b44737de009ea85c30a5611606d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc65d0aceb78338ff319e0a29d4e6f74e462dcd2e0e5b873eaba957c1ba7a8a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36ee588a84777f80672a003e012b940ae10437a6f546076128c62ff75debc969"
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
