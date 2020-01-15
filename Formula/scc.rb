class Scc < Formula
  desc "Fast and accurate code counter with complexity and COCOMO estimates"
  homepage "https://github.com/boyter/scc/"
  url "https://github.com/boyter/scc/archive/v2.10.1.tar.gz"
  sha256 "98a09aeeb3e6727b1663e8d9f8ac9bb53303928634fd3761464f34de4b382970"

  bottle do
    cellar :any_skip_relocation
    sha256 "c84250a5d2de756215dfda44f51b8c41c733120b0faea9a486fe575b8334c4d2" => :catalina
    sha256 "f20385f625dac231aa4b35e516740d7859761d66c42e7afbb3ff32a9919553c7" => :mojave
    sha256 "aad78487cd872af15c5379d3b7c54aa16fa37c5d009b6392db1b7fa23268e5b4" => :high_sierra
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
