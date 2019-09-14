class Scc < Formula
  desc "Fast and accurate code counter with complexity and COCOMO estimates"
  homepage "https://github.com/boyter/scc/"
  url "https://github.com/boyter/scc/archive/v2.8.0.tar.gz"
  sha256 "1a4a08d4c39b1168f6626dff59a821a09bfd1922d9b7732506ebf124408f4361"

  bottle do
    cellar :any_skip_relocation
    sha256 "6fdd19186df39437aaa7ecfad24b15da2f5c708142c75d42b28fe292dcecbfa3" => :mojave
    sha256 "4366f48f5f594af091e5f2a77fe91d038259554d1efc7965cf6afa27060c060c" => :high_sierra
    sha256 "ac1885a3b3451bdc910d641b558ef29e911e9e89b845e50eb67f64a001476c92" => :sierra
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
