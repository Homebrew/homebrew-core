class Uncrustify < Formula
  desc "Source code beautifier"
  homepage "https://uncrustify.sourceforge.net/"
  url "https://github.com/uncrustify/uncrustify/archive/refs/tags/uncrustify-0.78.1.tar.gz"
  sha256 "ecaf4c0adca14c36dfffa30bc28e69865115ecd602c90eb16a8cddccb41caad2"
  license "GPL-2.0-or-later"
  head "https://github.com/uncrustify/uncrustify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "988940baed6f80db45a495d387cfab38a75496ca60daf7f301adf34b1b445a57"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "88a407115693464ee05a99d035d1d13e437b30b0f99d79aaca5ecc7e5ee30d9d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d043b7e256a5fe4b858a34cd8f07f01c3fee3497010b1b97ee130968cc6a2b79"
    sha256 cellar: :any_skip_relocation, sonoma:         "1abf1020168856899d6c5f676c6162f90e4b3fc0e4ab6d89aa9e24bc7f52c9ca"
    sha256 cellar: :any_skip_relocation, ventura:        "b6b8b48c4c6f8b9b3c858fd75ef8558adb99ca143329d6b41b224908f9201965"
    sha256 cellar: :any_skip_relocation, monterey:       "f569a67342595fb813c61ee035622788e6a6df3a346dba3c4e4bcbc3afd8c952"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8bd176735277b4f2b2a23c17e5e044a900a2aedca1b16a357c8a13416b9a9cf2"
  end

  depends_on "cmake" => :build
  uses_from_macos "python" => :build

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
