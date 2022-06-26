class Uncrustify < Formula
  desc "Source code beautifier"
  homepage "https://uncrustify.sourceforge.io/"
  url "https://github.com/uncrustify/uncrustify/archive/uncrustify-0.75.1.tar.gz"
  sha256 "fd14acc0a31ed88b33137bdc26d32964327488c835f885696473ef07caf2e182"
  license "GPL-2.0-or-later"
  head "https://github.com/uncrustify/uncrustify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7eb7fec9fa0613684ce387cd7f139b50247ca224c971606c2496c5e4a1a75265"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a0c32a534c3fd8de75d6496b0d104ad160e8751c2a2f74640bd3b415b6c75a02"
    sha256 cellar: :any_skip_relocation, monterey:       "cac15eb7c3979bf75b6a24c2f57a366878ea6a98befbdde5912798a4b1b4ea20"
    sha256 cellar: :any_skip_relocation, big_sur:        "185507a328eaba61d4cf56ffeecd728aedbc800d6d84b8ea6a5f749f25c32e8b"
    sha256 cellar: :any_skip_relocation, catalina:       "efb42357c245fc69f64d000b33043504e67d28c587df47ce5b1c237e7e6e11b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61ecc6df45fafbe1c44b02c154bf1a0aed9dad0e9694d20209ed16aed392ad88"
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
