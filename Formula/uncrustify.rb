class Uncrustify < Formula
  desc "Source code beautifier"
  homepage "https://uncrustify.sourceforge.io/"
  url "https://github.com/uncrustify/uncrustify/archive/uncrustify-0.75.1.tar.gz"
  sha256 "fd14acc0a31ed88b33137bdc26d32964327488c835f885696473ef07caf2e182"
  license "GPL-2.0-or-later"
  head "https://github.com/uncrustify/uncrustify.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df2f51573eca7780661104e4f5749d2d45a412e0653af91a77d472ca8c0d2538"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "18fd62fc09199932669b7dae942275db9b01cb0f41426bb498d4c0c62fa281d4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "125f9215b38b8479bf19a3e2bd2a26b69d852330c5ea814efc4f321fd7c7845c"
    sha256 cellar: :any_skip_relocation, ventura:        "df56dc00daa0ccebd34531fb7abc8786f6f88cc4333dafdfb03124f0b8efbe33"
    sha256 cellar: :any_skip_relocation, monterey:       "91b46324697bb64ff4dd19a14b03c76f121413cee986b1fbbadc28ee9606dbe6"
    sha256 cellar: :any_skip_relocation, big_sur:        "d3aa70ab113276545fe3dcf0a29a1549f41e1f2237ffa3ee41ece14aeb321a4e"
    sha256 cellar: :any_skip_relocation, catalina:       "d9718ce807174f7673bd384b14df90b3e0089c95ae2d023f0dd51cbf895c5c51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33c4e0474ecf3ef68598a8babe888a568b87db5c1156c87c72c289e00e2df078"
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
