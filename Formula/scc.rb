class Scc < Formula
  desc "Fast and accurate code counter with complexity and COCOMO estimates"
  homepage "https://github.com/boyter/scc/"
  url "https://github.com/boyter/scc/archive/v2.8.0.tar.gz"
  sha256 "1a4a08d4c39b1168f6626dff59a821a09bfd1922d9b7732506ebf124408f4361"

  bottle do
    cellar :any_skip_relocation
    sha256 "304ac05f8c7c3949793df88ee144a610d52c1c0f45679565184bb74defe23e1c" => :catalina
    sha256 "3e63e9243d5d62a505e26ab39bd9f262b27f9f50caa0b01a4e347738cbd64a22" => :mojave
    sha256 "a828626f911108ea5225d52dd7cb4bb9f173df6463dd8d3d5ddc3fef62077e16" => :high_sierra
    sha256 "68473ca76511094d124d960da984e9107d78f77115f9eb40b246f6c95dc976f6" => :sierra
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
