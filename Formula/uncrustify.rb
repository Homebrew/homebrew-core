class Uncrustify < Formula
  desc "Source code beautifier"
  homepage "https://uncrustify.sourceforge.io/"
  url "https://github.com/uncrustify/uncrustify/archive/uncrustify-0.75.1.tar.gz"
  sha256 "fd14acc0a31ed88b33137bdc26d32964327488c835f885696473ef07caf2e182"
  license "GPL-2.0-or-later"
  head "https://github.com/uncrustify/uncrustify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae836c3cc1e1e0e027d6f0082e1eaf6052259b4895f8e4d86a332fa897a63e0b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b63b8b33cbbfbc0c5df109fd607733de9175ff1e92021592640515caa22d9e83"
    sha256 cellar: :any_skip_relocation, monterey:       "ef2310bbab7696e2ab990d083b37429a76288d2d6bb0dbe6e834a0277c76bf3e"
    sha256 cellar: :any_skip_relocation, big_sur:        "9bb5ac5befb9da7b6f5d58505aa577ac38d3eeddd1861214ce550cf579b3ad1d"
    sha256 cellar: :any_skip_relocation, catalina:       "2a77c5e3a4d198c8b3fb80f6d2d6d597fb89d299aa36ca01aee65f260e8ca08a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fae0bf279c7cb27ed982072f1749e49910886ee5cf44121d9667dfb36fce807e"
  end

  depends_on "cmake" => :build
  uses_from_macos "python" => :build

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    ENV.cxx11

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
