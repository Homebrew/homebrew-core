class Uncrustify < Formula
  desc "Source code beautifier"
  homepage "https://uncrustify.sourceforge.net/"
  url "https://github.com/uncrustify/uncrustify/archive/refs/tags/uncrustify-0.82.0.tar.gz"
  sha256 "e05f8d5ee36aaa1acfa032fe97546b7be46b1f4620e7c38037f8a42e25fe676f"
  license "GPL-2.0-or-later"
  head "https://github.com/uncrustify/uncrustify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d2147d198e4aa63bd7765b2bb793c62b99396db991cd1200136953042a4e9996"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0925adba92160a19225ee1ee15a3d0216cc40e64d0fa12543f7ae45a414ac430"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "986c576d015d2e421590aacc04c10c23931d39afb37ce526a86f027655a20066"
    sha256 cellar: :any_skip_relocation, sonoma:        "9452de45814ca613f1fd5497e356ed7ebf151e27892e899dd2de997b409ef5d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f77747fb27d76a15d3a9eae89e5ebaf02cad3890f21a3bc7cd82865dcff2befc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b069a15ffe6e93dcf3d6a7e1a8dbe108e7599c494ae9d67ddc3d64c1add0e898"
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
