class Scc < Formula
  desc "Fast and accurate code counter with complexity and COCOMO estimates"
  homepage "https://github.com/boyter/scc/"
  url "https://github.com/boyter/scc/archive/v2.13.0.tar.gz"
  sha256 "11e2e44ef25ef848de1b380c94cb096ed77d3d590466c99c9f1b5c2dc99609c2"
  license any_of: ["MIT", "Unlicense"]

  livecheck do
    url :homepage
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "66e94332b83430ce107eb5e529ca1a08b06adfed3ae258b35de391a2194a898d" => :big_sur
    sha256 "798591b31f8fa70978615076a78cb7adc556d4fb63e6901052728ce47106d4bd" => :catalina
    sha256 "76530a13d533fd2e54593a119e61f20796f746bfdceaebe01bc64b81e33eb308" => :mojave
    sha256 "f10f5e6376c18ace0dc1d9fa9c4f6cb8bd21720a4e16378693d6fe36b80195ed" => :high_sierra
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

    assert_match "C,test.c,test.c,4,4,0,0,0,50\n", shell_output("#{bin}/scc -fcsv test.c")
  end
end
