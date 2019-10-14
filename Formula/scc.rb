class Scc < Formula
  desc "Fast and accurate code counter with complexity and COCOMO estimates"
  homepage "https://github.com/boyter/scc/"
  url "https://github.com/boyter/scc/archive/v2.9.0.tar.gz"
  sha256 "9e5e3e3f50b46fa81556f0a8b4bbe5b77a2aa3f95703338b131287146a275120"

  bottle do
    cellar :any_skip_relocation
    sha256 "0fe105cd1408086a488b7e108f744e79721c25cbbc61d28fbe525e52b4a207ce" => :catalina
    sha256 "a463152c05461314f8f1a02adfc7ed530bfd2cc5fd8717984f790fc0b0bf6128" => :mojave
    sha256 "abeacd17d2c2c33ca14b9ca9374fd6e09eac31b012c26c92f1466bcc0653e7d2" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/boyter/scc/").install Dir["*"]
    system "go", "build", "-o", "#{bin}/scc", "-v", "github.com/boyter/scc/"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      int main(void) {
        return 0;
      }
    EOS

    assert_match "C,test.c,test.c,4,4,0,0,0\n", shell_output("#{bin}/scc -fcsv test.c")
  end
end
